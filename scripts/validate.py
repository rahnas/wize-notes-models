#!/usr/bin/env python3
"""Checks catalog.json: required fields, model references, and (with --remote) that each URL serves the
expected number of bytes."""
import json, sys, urllib.request

c = json.load(open("catalog.json"))
assert c["schemaVersion"] == 1
ids = {m["id"] for m in c["models"]}
for m in c["models"]:
    for k in ("id", "language", "displayName", "format", "url", "bytes", "sha256", "license", "source", "attribution"):
        assert m.get(k) not in (None, "", 0, "PENDING"), f"{m['id']}: missing {k}"
    assert len(m["sha256"]) == 64, f"{m['id']}: bad sha256"
for lang in c["languages"]:
    engines = [(p, e) for p, e in lang["engines"].items()]
    engines += [(p, e) for p, opts in lang.get("options", {}).items() for e in opts]
    for platform, engine in engines:
        if engine["type"] == "whisper":
            assert engine["model"] in ids, f"{lang['code']}/{platform}: unknown model {engine['model']}"
            assert engine.get("task") in (None, "translate"), f"{lang['code']}: bad task {engine.get('task')}"
if "--remote" in sys.argv:
    for m in c["models"]:
        req = urllib.request.Request(m["url"], method="HEAD")
        with urllib.request.urlopen(req) as r:
            size = int(r.headers.get("Content-Length", 0))
        print(("ok  " if size == m["bytes"] else "BAD ") + f"{m['id']}: {size} bytes")
print("catalog.json is valid")
