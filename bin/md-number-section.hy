#!/usr/bin/env hy

(import re)
(import sys)
(import hyrule *)
(require hyrule *)

(defn assert-eq [a b]
  (assert (= a b)))

(defn remove-prefix-pound-sign [s]
  (.strip (re.sub r"^\#+" "" s)))

(assert-eq
  (remove-prefix-pound-sign "### title 3")
  "title 3") 

(defn str-count-start-char [s c]
 (setv index 0)
 (while (and
             (< index (len s))
             (= (get s index) c))
        (+= index 1))
 index)

(assert-eq
 (str-count-start-char "### title 3" "#")
 3)

(defn get-header-level [header]
 (str-count-start-char header "#"))

(defn get-header-content [header]
 (.strip (re.sub
           r"^#+\s+(\d+(\.\d)*)*" "" header)))

(assert-eq (get-header-content "### 1.2.3 title 3")
           "title 3")
(assert-eq (get-header-content "### title 3")
           "title 3")

(defn get-header-ref [header]
  (as-> (remove-prefix-pound-sign header) it
        (.lower it)
        (re.sub r"[.]" "" it)
        (.replace it " " "-")
        (re.sub r"-+" "-" it)))


(assert-eq
  (get-header-ref "### 1.2.3 title 3")
  "123-title-3")

(defn arr-pad [arr num val]
  (if (< (len arr) num)
    (+ arr (* [val] (- num (len arr))))
    arr))

(assert-eq
  (arr-pad ["1" "2" "3"] 5 "0")
  ["1" "2" "3" "0" "0"])

(defn assocr [coll k1 v1]
  (assoc coll k1 v1)
  coll)

(defn inc-str [s]
  (as-> (int s) it
        (inc it)
        (str it)))

(assert-eq
    (inc-str "9")
    "10")

(defn semver-add-by-index [old inc level]
  (as-> (.split old ".") it
        (cut it 0 level)
        (arr-pad it level "0")
        (assocr it -1 (inc-str (get it -1)))
        (.join "." it)))

(assert-eq
    (semver-add-by-index "1.2" 1 1)
    "2")
(assert-eq
    (semver-add-by-index "1.2" 1 2)
    "1.3")
(assert-eq
    (semver-add-by-index "1.2" 1 3)
    "1.2.1")
(assert-eq
    (semver-add-by-index "1.2" 1 4)
    "1.2.0.1")

(defn renumber-md [doc]
  (setv last-ver "0"
        changed-header [])
  (setv doc
    (re.sub 
      r"^```[\s\S]*?^```|^#+.*"
      (fn [match]
        (nonlocal last-ver changed-header)
        (let [block (match.group 0)]
             (if (block.startswith "#")
               (do
                 (setv last-ver
                       (semver-add-by-index 
                         last-ver 1
                         (get-header-level block)))
                 (setv add-line (.join " "
                                  [(* "#" (get-header-level block))
                                   last-ver 
                                   (get-header-content block)]))
                 (changed-header.append [block add-line])
                 add-line)
               block)))
      doc
      :flags re.MULTILINE))
  [doc changed-header])
 
 
(assert-eq
  (renumber-md "
# title 1
daf
## subtitle 1
# title2
heih
## subtitle2")
  ["\n# 1 title 1\ndaf\n## 1.1 subtitle 1\n# 2 title2\nheih\n## 2.1 subtitle2" 
   [["# title 1" "# 1 title 1"] ["## subtitle 1" "## 1.1 subtitle 1"] ["# title2" "# 2 title2"] ["## subtitle2" "## 2.1 subtitle2"]]])

(defn replace-header-ref [doc changed-header]
 (for [h changed-header]
  (let [fr (get-header-ref (get h 0))
        to (get-header-ref (get h 1))]
       (when
         (!= fr to)
         (setv
           doc
           (re.sub
             rf"\[([^]\r\n]*)\]\(#{(re.escape fr)}\)"
             rf"[\1](#{to})"
             doc)))))
 doc)
 

(assert-eq
    (replace-header-ref "[title](#1-title)" [["# 1 title" "# 3 title"]])
    "[title](#3-title)")


(defn read-file [f] 
 (with [f (open f)]
  (.read f)))

(defn write-file [f content] 
 (with [f (open f "w")]
  (.write f content)))

(defmain [prog file]
 (as-> (read-file file) it
       (renumber-md it)
       (replace-header-ref #* it)
       (write-file file it)))
 
