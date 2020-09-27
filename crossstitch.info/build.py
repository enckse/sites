import os
import argparse
import sys


def _row(data):
    return "| {} |".format(" | ".join(data))


def main():
    """Program entry."""
    parser = argparse.ArgumentParser()
    parser.add_argument("title")
    parser.add_argument("target")
    parser.add_argument("dir")
    parser.add_argument("--preamble", type=str, default=None)
    parser.add_argument("--columns", type=int, default=2)
    parser.add_argument("--latest", action="store_true")
    args = parser.parse_args()
    files = sorted(os.listdir(args.dir))
    jpgs = [x for x in files if x.endswith(".jpg")]
    others = [x for x in files if x not in jpgs]
    count = 0
    lines = []
    current = []
    latest_mod = None
    latest = None
    for j in jpgs:
        current += [j]
        if count == args.columns:
            lines.append(current)
            current = []
            count = -1
        count += 1
        if args.latest:
            mod = os.path.getmtime(os.path.join(args.dir, j))
            if latest_mod is None or mod > latest_mod:
                latest_mod = mod
                latest = j
    if len(current) > 0:
        while len(current) <= args.columns:
            current += [""]
        lines.append(current)
    text = [args.title, "==="]
    if args.preamble and os.path.exists(args.preamble):
        with open(args.preamble, 'r') as f:
            text = [f.read()]
    columns = []
    column_delimiter = []
    count = 0
    while count <= args.columns:
        columns += [""]
        column_delimiter += ["---"]
        count += 1
    if latest is not None:
        text += ["---",
                 "## latest",
                 "",
                 "",
                 "![{}]({})".format(latest, os.path.join("/", args.dir, latest)),
                 "",
                 "---",
                 ""]
    text += [""]
    text += [_row(columns)]
    text += [_row(column_delimiter)]
    for l in lines:
        header = []
        data = []
        for obj in l:
            if not obj:
                header += [""]
                data += [""]
                continue
            f_name = obj.replace(".jpg", "")
            raw = os.path.join("/", args.dir, obj)
            data += ["[![{}]({})]({})".format(f_name, raw, raw)]
            pdf = [x for x in others if x == f_name + ".pdf"]
            if len(pdf) != 1:
                raise Exception("no pdf for {}".format(f_name))
            pdf = pdf[0]
            header += ["[{} (pattern pdf)]({})".format(f_name, os.path.join("/", args.dir, pdf))]
            others = [x for x in others if x != pdf]
        text += [_row(header)]
        text += [_row(data)]
    if len(others) > 0:
        print("untracked resources: {}".format(others))
    with open(args.target, 'w') as f:
        f.write("\n".join(text))
            

if __name__ == "__main__":
    main()
