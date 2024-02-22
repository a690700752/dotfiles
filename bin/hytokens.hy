(import re)
(import common *)
(require hyrule [as-> let+ setv+])
(import hyrule [inc dec pprint])

(setv TOKEN_IDENTIFIER "Identifier"
      TOKEN_PUNCTUATION "Punctuation"
      TOKEN_WHITESPACE "Whitespace"
      TOKEN_NEWLINE "Newline"
      TOKEN_STRING "String"
      TOKEN_BRACKET_STRING "BracketString"
      TOKEN_COMMENT "Comment"
      TOKEN_SHEBANG "Shebang"
      TOKEN_START "Start"
      TOKEN_END "End")

(setv Whitespace (re.compile r"[ \t]+")
      Newline (re.compile r"\n")
      Identifier (re.compile r"[0-9a-zA-Z_\-+><=?.:*!]+")
      String (re.compile r"(r|f)?\"([^\\\"]|\\.)*\"")
      Punctuation (re.compile r"[\{\}\[\]\(\)`~]")
      BracketStringStart (re.compile r"#\[(\w*)\[")
      Comment (re.compile r";.*"))


(defn tokenize_seq [input]
      (setv tokens [])
      (setv line 0)
      
      (when (input.startswith "#!")
            (setv line_idx (input.find "\n"))
            (when (= -1 line_idx)
                  (setv line_idx (len input)))
            (setv val (cut input line_idx))
            (tokens.append {"line" line "type" TOKEN_SHEBANG "val" val})
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
                         (tokens.append {"line" line "type" TOKEN_BRACKET_STRING "val" content})
                         (setv input (cut input pos_end None))
                         (continue)))
             
             (for [c [[Comment TOKEN_COMMENT]
                      [Newline TOKEN_NEWLINE (fn [] {"new_line" (inc line)})]
                      [Whitespace TOKEN_WHITESPACE]
                      [Punctuation TOKEN_PUNCTUATION]
                      [String TOKEN_STRING]
                      [Identifier TOKEN_IDENTIFIER]]]
                  (setv res (.match (get c 0) input))
                  (when res
                        (tokens.append {"line" line "type" (get c 1) "val" (.group res)})
                        (setv input (cut input (.end res) None))
                        (when (and (> (len c) 2) (get c 2))
                              (let+ [{new_line "new_line"} ((get c 2))]
                                    (when (!= None new_line))
                                    (setv line new_line)))
                        
                        (break)))
             
             (when (not res)
                   (raise (Exception f"Unexpected input: {input}")))) tokens)


(defn get_end_pair [open_pair]
      (cond
            (= open_pair "(") ")"
            (= open_pair "{") "}"
            (= open_pair "[") "]"
            True (raise (Exception f"Unexpected open pair: {open_pair}"))))

(defn tokenize_tree_helper [cur_token wait_token tokens i]
      (setv childs [])
      (setv close_token None)
      (while (< i (len tokens))
             (let+ [token (get tokens i)
                     {type "type" val "val"} token]
                   (cond
                         (and (= type (get wait_token "type"))
                              (= val (get wait_token "val")))
                         (do
                             (setv close_token token)
                             (+= i 1)
                             (break))
                         
                         (and (= type TOKEN_PUNCTUATION) (in val ["(" "[" "{"]))
                         (let [node (tokenize_tree_helper token {"type" TOKEN_PUNCTUATION "val" (get_end_pair val)} tokens (inc i))]
                              (childs.append node)
                              (setv i (get node "i")))
                         
                         True (do (childs.append token) (+= i 1)))))
      {"open_token" cur_token
        "close_token" close_token
        "childs" childs "i" i})

(defn tokenize_tree_from_tokens [tokens]
      (setv end_token {"line" 0 "type" TOKEN_END "val" None})
      (tokens.append end_token)
      (tokenize_tree_helper {"line" 0 "type" TOKEN_START "val" None}
                            end_token
                            tokens 0))

(defn tokenize_tree [input]
      (tokenize_tree_from_tokens (tokenize_seq input)))

(tokenize_tree #[[
                  (import re haha (get ddd "name"))]])

