#!/usr/bin/env python3

import inspect
import re
from termcolor import colored


TOKEN_TYPE_DELIMITER = "DELIMITER"
TOKEN_TYPE_IDENTIFIER = "IDENTIFIER"


class Token:
    def __init__(self, typ, s):
        self.typ = typ
        self.s = s

    def __repr__(self):
        return self.s


def parse_tokens(s: str):
    i = 0
    while i < len(s):
        if s[i] == "(":
            yield Token(TOKEN_TYPE_DELIMITER, s[i])
            i += 1
        elif s[i] == ")":
            yield Token(TOKEN_TYPE_DELIMITER, s[i])
            i += 1
        elif s[i] == " ":
            i += 1
        else:
            j = i
            while j < len(s) and s[j] != " " and s[j] != ")":
                j += 1
            token_str = s[i:j]
            if s[i:j].startswith("@."):
                var = s[i:j][2:]
                if not var:
                    raise Exception(f"empty variable name at {token_str}")

                # todo extract
                print(f"var: {var}")
                yield Token(TOKEN_TYPE_DELIMITER, "(")
                yield Token(TOKEN_TYPE_IDENTIFIER, "idx")
                yield Token(TOKEN_TYPE_IDENTIFIER, var)
                yield Token(TOKEN_TYPE_DELIMITER, ")")
            else:
                yield Token(TOKEN_TYPE_IDENTIFIER, s[i:j])
            i = j


def find_end_parens(tokens: list):
    cnt = 0
    i = 0
    while i < len(tokens):
        if tokens[i].typ == TOKEN_TYPE_DELIMITER:
            if tokens[i].s == "(":
                cnt += 1
            elif tokens[i].s == ")":
                cnt -= 1
                if cnt == 0:
                    return i
        i += 1

    raise Exception(f"unbalanced parens\n{tokens_error(tokens, 0)}")


def tokens_error(tokens: list, i):
    return " ".join(
        [colored(x.s, "red") if j == i else x.s for j, x in enumerate(tokens)]
    )


def build_tree(tokens: list):
    i = 0
    res = []
    while i < len(tokens):
        if tokens[i].typ == TOKEN_TYPE_DELIMITER:
            if tokens[i].s == "(":
                j = find_end_parens(tokens[i:])
                res.append(build_tree(tokens[i + 1 : i + j]))
                i += j
            else:
                raise Exception(f"unexpected delimiter at \n{tokens_error(tokens, i)}")
        elif tokens[i].typ == TOKEN_TYPE_IDENTIFIER:
            res.append(tokens[i].s)
        i += 1

    return res


def m_eval(args: list):
    if args[0] in func_map:
        return m_apply(args)
    else:
        raise Exception(f"unknown function {args[0]}")


def m_apply(args: list):
    if args[0] in func_map:
        return func_map[args[0]]([m_eval(x) if type(x) == list else x for x in args])
    else:
        raise Exception(f"unknown function {args[0]}")


def m_val(identify, x):
    if callable(identify):
        return identify(x)
    return x


def func_gt(args: list):
    if args[1] == "@":
        return lambda x: x > float(m_val(args[2], x))
    elif args[2] == "@":
        return lambda x: m_val(args[1], x) > x
    else:
        return lambda x: float(m_val(args[1], x)) > float(m_val(args[2], x))


def func_lt(args: list):
    if args[1] == "@":
        return lambda x: x < float(args[2])
    elif args[2] == "@":
        return lambda x: args[1] < x
    else:
        return lambda x: float(args[1]) < float(args[2])


def func_eq(args: list):
    if args[1] == "@":
        return lambda x: x == float(args[2])
    elif args[2] == "@":
        return lambda x: args[1] == x
    else:
        return lambda x: float(args[1]) == float(args[2])


func_map = {
    "gt": func_gt,
    "lt": func_lt,
    "eq": func_eq,
    "ne": lambda args: lambda x: not func_eq(args)(x),
    "gte": lambda args: lambda x: not func_lt(args)(x),
    "lte": lambda args: lambda x: not func_gt(args)(x),
    "and": lambda args: lambda x: args[1](x) and args[2](x),
    "or": lambda args: lambda x: args[1](x) or args[2](x),
    "filter": lambda args: lambda l: list(filter(args[1], l)),
    "+1": lambda args: lambda x: x + 1,
}


def eval_str(s: str):
    if not s.startswith("("):
        s = "(" + s + ")"
    return m_eval(build_tree(list(parse_tokens(s)))[0])


def main():
    # print(eval_str("filter (gt 4 3)")([1, 2, 3, 4, 5, 6]))
    print(eval_str("(filter (gt @ 3) @)")([1, 2, 3, 4, 5, 6]))
    # print(eval_str("filter (eq @.x 3)")([{"x": 3}, {"x": 4}]))


if __name__ == "__main__":
    main()


# lisp:
# (defn fn [l] (filter (@gt @ 2) l))
def fn(l):
    filter(lambda x: x > 2, l)
