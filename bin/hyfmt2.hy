#!/usr/bin/env hy

(import re)
(import sys)
(import argparse [ArgumentParser])
(import hytokens *)
(require hyrule [->
                  ->>
                  as->
                  block
                  ap-map
                  ap-reduce
                  case
                  let+
                  setv+])
(import hyrule [inc dec])

(defn last_line [code]
      (if (not code) ""
          (cut code (inc (.rfind code "\n")) None)))

(assert (= (last_line "abc\ndef") "def"))
(assert (= (last_line "abc") "abc"))
(assert (= (last_line "") ""))

(defn append_identifier [code identifier]
      (if (in (last code) ["(" "[" "{" " " "\n" None "~"])
          (+ code identifier)
          (+ code " " identifier)))

(assert (= (append_identifier "(" "filter") "(filter"))
(assert (= (append_identifier "(filter" "name") "(filter name"))

(defn append_newline [code indent]
      (+ code "\n" (* " " indent)))

(assert (= (append_newline "(filter" 3) "(filter\n   "))

(defn append_shebang [code shebang] (+ code shebang))

(assert (= (append_shebang "" "#!/usr/bin/env python") "#!/usr/bin/env python"))

(defn append_comment [code comment] (+ code comment))
(assert (= (append_comment "" "; this is a comment") "; this is a comment"))

(defn append_puctuation [code punctuation]
      (setv n_code
            (cond
                  (in punctuation [")" "]" "}"])
                  (+ (.rstrip code) punctuation)
                  (in punctuation ["(" "[" "{" "`" "~"])
                  (if (in (last code) ["(" " " "[" "{" "\n" None "`"])
                      (+ code punctuation)
                      (+ code " " punctuation))
                  True (raise (Exception f"Unexpected punctuation: {punctuation}"))))
      
      
      (setv col (dec (len (last_line n_code))))
      
      (dict :code n_code :col col))

(assert (= (append_puctuation "" "(") (dict :code "(" :col 0)))
(assert (= (append_puctuation "\n" "(") (dict :code "\n(" :col 0)))
(assert (= (append_puctuation "(filter" "(") (dict :code "(filter (" :col 8)))
(assert (= (append_puctuation "(filter name\n    " ")") (dict :code "(filter name)" :col 12)))

(defn append_string [code string]
      (if (in (last code) ["(" "[" "{" "\n" " " None])
          (+ code string)
          (+ code " " string)))

(assert (= (append_string "" "\"hello\"") "\"hello\""))
(assert (= (append_string "hello" "\"world\"") "hello \"world\""))

(defn open_punctuation? [punctuation]
      (in punctuation ["(" "[" "{"]))

(assert (= (open_punctuation? "(") True))
(assert (= (open_punctuation? "}") False))
(assert (= (open_punctuation? "") False))

(defn close_punctuation? [punctuation]
      (in punctuation [")" "]" "}"]))

(defn get_indent [bracket_stack]
      (if (empty? bracket_stack) 0
          (let+ [{bracket "bracket"
                   first_arg "first_arg"
                   col "col"}
                  (last bracket_stack)]
                
                (+ col
                   (if (= bracket "(")
                       (if (or (empty? first_arg)
                               (open_punctuation? first_arg))
                           2
                           (+ 2 (len first_arg)))
                       2)))))

(assert (= (get_indent []) 0))
(assert (= (get_indent [(dict :col 2 :bracket "(" :first_arg "")]) 4))
(assert (= (get_indent [(dict :col 2 :bracket "(" :first_arg "") (dict :col 4 :bracket "(" :first_arg "")]) 6))
(assert (= (get_indent [(dict :col 2 :bracket "(" :first_arg "filter")]) 10))
(assert (= (get_indent [(dict :col 2 :bracket "(" :first_arg "defn") (dict :col 5 :bracket "(" :first_arg "print")]) 12))

(defn print_token_tree [token_tree]
      (setv code "")

      (setv code (append_puctuation code (get token_tree :open_token :val)))
      
      (for [token (.get token_tree :childs)]
           (let+ [{type "type" line "line" val "val"} token]
                 (cond
                       (= type TOKEN_SHEBANG) (setv code (append_shebang code val))
                       (= type TOKEN_COMMENT) (setv code (append_comment code val))
                       (= type TOKEN_PUNCTUATION)
                       (do
                           (setv+ {code "code" col "col"} (append_puctuation code val))
                           (cond (open_punctuation? val)
                                 (do (when (and (last bracket_stack) (not (get (last bracket_stack) "first_arg")))
                                           (setv (get (last bracket_stack) "first_arg") val))
                                     (bracket_stack.append (dict :bracket val :first_arg "" :line line :col col)))
                                 (close_punctuation? val)
                                 (when bracket_stack (.pop bracket_stack))))
                       (= type TOKEN_STRING) (setv code (append_string code val))
                       (= type TOKEN_IDENTIFIER)
                       (do (setv code (append_identifier code val))
                           (when (and (last bracket_stack)
                                      (not (get (last bracket_stack) "first_arg")))
                                 (setv (get (last bracket_stack) "first_arg") val)))
                       
                       (= type TOKEN_BRACKET_STRING) (setv code (append_string code val))
                       (= type TOKEN_NEWLINE) (setv code (append_newline code (get_indent bracket_stack))))))

      (setv code (append_puctuation code (get token_tree :close_token :val)))
      code)


(let
     [parser (ArgumentParser)]
     (.add_argument parser "path" :nargs "*")
     (.add_argument parser "-w" :action "store_true")
     (setv args (.parse_args parser))
     
     (if args.path
         (for [path args.path]
              (setv code
                    (with [f (open path "r")] (.read f)))
              (setv formatted (print_tokens (tokenize code)))
              (if args.w
                  (when (!= code formatted)
                        (do (with [f (open path "w")]
                                  (.write f formatted))))
                  (print formatted "end")))
         (do
             (setv code (.read sys.stdin))
             (print (print_tokens (tokenize code))
                    :end ""))))
