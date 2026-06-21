#!/usr/bin/env python3
"""YOLOv5 OM inference on Atlas 200I DK — AclLite + numpy/cv2 (no torch)."""
import argparse
import os
import sys
import time

import cv2
import numpy as np

# CANN env
sys.path.insert(0, "/usr/local/Ascend/thirdpart/aarch64/acllite")
sys.path.insert(0, "/usr/local/Ascend/ascend-toolkit/latest/python/site-packages")

from acllite_model import AclLiteModel
from acllite_resource import AclLiteResource


def letterbox(img, new_shape=(640, 640), color=(114, 114, 114)):
    shape = img.shape[:2]
    r = min(new_shape[0] / shape[0], new_shape[1] / shape[1])
    new_unpad = int(round(shape[1] * r)), int(round(shape[0] * r))
    dw, dh = new_shape[1] - new_unpad[0], new_shape[0] - new_unpad[1]
    dw, dh = dw / 2, dh / 2
    if shape[::-1] != new_unpad:
        img = cv2.resize(img, new_unpad, interpolation=cv2.INTER_LINEAR)
    top, bottom = int(round(dh - 0.1)), int(round(dh + 0.1))
    left, right = int(round(dw - 0.1)), int(round(dw + 0.1))
    img = cv2.copyMakeBorder(img, top, bottom, left, right, cv2.BORDER_CONSTANT, value=color)
    return img, r, (dw, dh)


def scale_coords(img1_shape, coords, img0_shape, ratio_pad):
    gain = ratio_pad[0]
    pad = ratio_pad[1]
    coords[:, [0, 2]] -= pad[0]
    coords[:, [1, 3]] -= pad[1]
    coords[:, :4] /= gain
    coords[:, [0, 2]] = coords[:, [0, 2]].clip(0, img0_shape[1])
    coords[:, [1, 3]] = coords[:, [1, 3]].clip(0, img0_shape[0])
    return coords


def postprocess(pred, conf_thres=0.4, iou_thres=0.5):
    """pred: (1, N, 85) numpy"""
    p = pred[0]
    obj = p[:, 4]
    cls_scores = p[:, 5:]
    cls_ids = cls_scores.argmax(1)
    cls_conf = cls_scores[np.arange(len(p)), cls_ids]
    conf = obj * cls_conf
    mask = conf > conf_thres
    if not mask.any():
        return np.zeros((0, 6))
    p = p[mask]
    conf = conf[mask]
    cls_ids = cls_ids[mask]
    # xywh -> xyxy
    boxes = np.zeros((len(p), 4), dtype=np.float32)
    boxes[:, 0] = p[:, 0] - p[:, 2] / 2
    boxes[:, 1] = p[:, 1] - p[:, 3] / 2
    boxes[:, 2] = p[:, 0] + p[:, 2] / 2
    boxes[:, 3] = p[:, 1] + p[:, 3] / 2
    idx = cv2.dnn.NMSBoxes(boxes.tolist(), conf.tolist(), conf_thres, iou_thres)
    if len(idx) == 0:
        return np.zeros((0, 6))
    idx = np.array(idx).reshape(-1)
    out = np.zeros((len(idx), 6), dtype=np.float32)
    out[:, :4] = boxes[idx]
    out[:, 4] = conf[idx]
    out[:, 5] = cls_ids[idx]
    return out


def load_labels(path):
    with open(path, encoding="utf-8") as f:
        return [ln.strip() for ln in f if ln.strip()]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="yolo.om")
    ap.add_argument("--image", default="world_cup.jpg")
    ap.add_argument("--labels", default="coco_names.txt")
    ap.add_argument("--out", default="world_cup_detect.jpg")
    ap.add_argument("--conf", type=float, default=0.4)
    ap.add_argument("--iou", type=float, default=0.5)
    args = ap.parse_args()

    img0 = cv2.imread(args.image)
    if img0 is None:
        raise SystemExit(f"cannot read {args.image}")
    labels = load_labels(args.labels)

    img, ratio, pad = letterbox(img0, (640, 640))
    blob = img[:, :, ::-1].transpose(2, 0, 1).astype(np.float32)
    blob = np.ascontiguousarray(blob[None, ...])

    res = AclLiteResource()
    res.init()
    model = AclLiteModel(args.model)

    t0 = time.time()
    outputs = model.execute([blob])
    infer_ms = (time.time() - t0) * 1000
    pred = outputs[0]
    if hasattr(pred, "numpy"):
        pred = pred.numpy()
    pred = np.asarray(pred)

    dets = postprocess(pred, args.conf, args.iou)
    dw, dh = pad
    dets = scale_coords((640, 640), dets.copy(), img0.shape[:2], (ratio, (dw, dh)))

    print(f"infer={infer_ms:.1f}ms detections={len(dets)}")
    for i, d in enumerate(dets[:15]):
        cid = int(d[5])
        name = labels[cid] if cid < len(labels) else str(cid)
        print(f"  [{i}] {name} conf={d[4]:.3f} box=[{d[0]:.0f},{d[1]:.0f},{d[2]:.0f},{d[3]:.0f}]")

    vis = img0.copy()
    for d in dets:
        if d[4] < args.conf:
            continue
        cid = int(d[5])
        name = labels[cid] if cid < len(labels) else str(cid)
        cv2.rectangle(vis, (int(d[0]), int(d[1])), (int(d[2]), int(d[3])), (0, 255, 0), 2)
        cv2.putText(vis, f"{name} {d[4]:.2f}", (int(d[0]), int(d[1]) + 16),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 1)
    cv2.imwrite(args.out, vis)
    print(f"saved {args.out}")


if __name__ == "__main__":
    main()
