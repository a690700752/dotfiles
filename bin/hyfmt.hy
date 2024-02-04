#!/usr/bin/env hy

(import re)
(import argparse [ArgumentParser])
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

(setv TOKEN_IDENTIFIER "Identifier"
      TOKEN_PUNCTUATION "Punctuation"
      TOKEN_WHITESPACE "Whitespace"
      TOKEN_NEWLINE "Newline"
      TOKEN_STRING "String"
      TOKEN_BRACKET_STRING "BracketString"
      TOKEN_COMMENT "Comment"
      TOKEN_SHEBANG "Shebang")

(setv Whitespace (re.compile r"[ \t]+"))
(setv Newline (re.compile r"\n"))
(setv Identifier (re.compile r"[0-9a-zA-Z_\-+><=?.:*!]+"))
(setv String (re.compile r"(r|f)?\"([^\\\"]|\\.)*\""))
(setv Punctuation (re.compile r"[\{\}\[\]\(\)]"))
(setv BracketStringStart (re.compile r"#\[(\w*)\["))
(setv Comment (re.compile r";.*"))

(defn empty? [x] (if x False True))
(defn first [x] (get x 0))
(defn last [x] (get x -1))

(defn tokenize [input]
      (setv tokens [])
      (setv line 0)
      
      (when (input.startswith "#!")
            (setv line_idx (input.find "\n"))
            (when (= -1 line_idx)
                  (setv line_idx (len input)))
            (setv val (cut input line_idx))
            (tokens.append (dict :type TOKEN_SHEBANG :val val))
            (setv input (cut input line_idx None)))
      
      (while input
             (setv res None)
             
             (when (not res)
                   (setv res (BracketStringStart.match input))
                   (when res
                         (setv tag (res.group 1))
                         (setv pos_start (input.find (+ "]" tag "]")))
                         (if (= -1 pos_start)
                             (setv pos_end (len input))
                             (setv pos_end (+ pos_start (len (+ "]" tag "]")))))
                         (setv content (cut input (.start res) pos_end))
                         (tokens.append (dict :type TOKEN_BRACKET_STRING :val content))
                         (setv input (cut input pos_end None))
                         (continue)))
             
             (for [c [[Comment TOKEN_COMMENT]
                       [Newline TOKEN_NEWLINE (fn [] {:new_line (inc line)})]
                       [Whitespace TOKEN_WHITESPACE]
                       [Punctuation TOKEN_PUNCTUATION]
                       [String TOKEN_STRING]
                       [Identifier TOKEN_IDENTIFIER]]]
                  (setv res (.match (get c 0) input))
                  (when res
                        (tokens.append (dict :line line :type (get c 1) :val (.group res)))
                        (setv input (cut input (.end res) None))
                        (when (and (> (len c) 2) (get c 2))
                              (let+ [{new_line :new_line} ((get c 2))]
                                    (when (!= None new_line))
                                    (setv line new_line)))
                        
                        (break)))
             
             (when (not res)
                   (raise (Exception f"Unexpected input: {input}")))) tokens)

(defn code_last_char [code]
      (if code (last code) None))

(assert (= (code_last_char "abc") "c"))
(assert (= (code_last_char "") None))

(defn code_last_line [code]
      (if (not code) ""
          (cut code (inc (.rfind code "\n")) None)))

(assert (= (code_last_line "abc\ndef") "def"))
(assert (= (code_last_line "abc") "abc"))
(assert (= (code_last_line "") ""))

(defn append_identifier [code identifier]
      (if (in (code_last_char code) ["(" "[" "{" " " "\n" None])
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
      (setv n_code (if (in punctuation [")" "]" "}"])
                       (+ (.rstrip code) punctuation)
                       (if (in (code_last_char code) ["(" " " "[" "{" "\n" None])
                           (+ code punctuation)
                           (+ code " " punctuation))))
      
      (setv col (dec (len (code_last_line n_code))))
      
      (dict :code n_code :col col))


(assert (= (append_puctuation "" "(") (dict :code "(" :col 0)))
(assert (= (append_puctuation "\n" "(") (dict :code "\n(" :col 0)))
(assert (= (append_puctuation "(filter" "(") (dict :code "(filter (" :col 8)))
(assert (= (append_puctuation "(filter name\n    " ")") (dict :code "(filter name)" :col 12)))

(defn append_string [code string]
      (if (in (code_last_char code) ["(" "[" "{" "\n" " " None])
          (+ code string)
          (+ code " " string)))

(assert (= (append_string "" "\"hello\"") "\"hello\""))
(assert (= (append_string "hello" "\"world\"") "hello \"world\""))

(defn open_punctuation? [punctuation]
      (in punctuation ["(" "[" "{"]))

(assert (= (open_punctuation? "(") True))
(assert (= (open_punctuation? "}") False))
(assert (= (open_punctuation? "") False))

(defn close_bracket? [bracket open]
      (or (and (= open "(") (= bracket ")"))
          (and (= open "[") (= bracket "]"))
          (and (= open "{") (= bracket "}"))))

(defn get_indent [bracket_stack]
      (if (empty? bracket_stack) 0
          (let+ [{bracket "bracket" first_arg "first_arg" col "col"} (last bracket_stack)]
                (+ col (if (= bracket "(")
                           (if (or (empty? first_arg) (open_punctuation? first_arg))
                               2
                               (+ 2 (len first_arg)))
                           2)))))

(assert (= (get_indent []) 0))
(assert (= (get_indent [(dict :col 2 :bracket "(" :first_arg "")]) 4))
(assert (= (get_indent [(dict :col 2 :bracket "(" :first_arg "") (dict :col 4 :bracket "(" :first_arg "")]) 6))
(assert (= (get_indent [(dict :col 2 :bracket "(" :first_arg "filter")]) 10))
(assert (= (get_indent [(dict :col 2 :bracket "(" :first_arg "defn") (dict :col 5 :bracket "(" :first_arg "print")]) 12))

(defn print_tokens [tokens]
      (setv code "")
      (setv bracket_stack [])
      
      (defn get_last_bracket [] (if (empty? bracket_stack) None (last bracket_stack)))
      
      (for [token tokens]
           (let+ [{type "type" line "line" val "val"} token]
                 (cond
                       (= type TOKEN_SHEBANG) (setv code (append_shebang code val))
                       (= type TOKEN_COMMENT) (setv code (append_comment code val))
                       (= type TOKEN_PUNCTUATION)
                       (do
                           (setv+ {code "code" col "col"} (append_puctuation code val))
                           (if (open_punctuation? val)
                               (do (when (and (get_last_bracket) (not (get (get_last_bracket) "first_arg")))
                                         (setv (get (get_last_bracket) "first_arg") val))
                                   (bracket_stack.append (dict :bracket val :first_arg "" :line line :col col)))
                               (when bracket_stack (.pop bracket_stack))))
                       (= type TOKEN_STRING) (setv code (append_string code val))
                       (= type TOKEN_IDENTIFIER)
                       (do (setv code (append_identifier code val))
                           (when (and (get_last_bracket)
                                      (not (get (get_last_bracket) "first_arg")))
                                 (setv (get (get_last_bracket) "first_arg") val)))
                       
                       (= type TOKEN_BRACKET_STRING) (setv code (append_string code val))
                       (= type TOKEN_NEWLINE) (setv code (append_newline code (get_indent bracket_stack))))))
      code)


(let
     [parser (ArgumentParser)]
     (.add_argument parser "path" :nargs "*")
     (.add_argument parser "-w" :action "store_true")
     (setv args (.parse_args parser))
     (for [path args.path]
          (setv code
                (with [f (open path "r")] (.read f)))
          (setv formatted (print_tokens (tokenize code)))
          (if
              args.w
              (do
                  (with [f (open path "w")]
                        (.write f formatted)))
              (print formatted))))