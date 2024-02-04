#!/usr/bin/env hy

(import prettytable [PrettyTable])
(import argparse [ArgumentParser])
(import sys)
(import re)
(require hyrule [->>])

(setv builtin_filter filter)

(defn try_parse_number [s]
      (try
           (if (in "." s)
               (float s)
               (int s))
           (except [ValueError]
                   s)))

(defn pad_arr [arr n val]
      (if (< (len arr) n)
          (+ arr (* [val] (- n (len arr))))
          arr))

(defn empty? [arr]
      (= (len arr) 0))

(defn print_table [table]
      (if (empty? table) None
          (let [x (PrettyTable)
                 max_len (max (map (fn [row] (len row)) table))]
               (setv x.field_names (range max_len))
               (for [row table]
                    (.add_row x (pad_arr row max_len "")))
               (print x))))

(defn list? [x]
      (= (type x) list))

(defn m_get [col key]
      (if (list? col)
          (get col (int key))
          (.get col key)))

(defn construct_query [in]
      (->> (+ "(" in " table)")
           (re.sub r"it\.(\w+)" "(m_get it \"\\1\")")))

(defn eval_query [query table]
      (defmacro filter [func iter]
                ` (builtin_filter (fn [it] ~ func) ~ iter))

(list (hy.eval (hy.read (construct_query query)) :macros (local_macros))))

(defn main []
      (let [parser (ArgumentParser)]
           (.add_argument parser "query" :nargs "?")
           (setv args (.parse_args parser))
           (setv table [])
           (for [val (enumerate sys.stdin)]
                (.append table (+ [(get val 0)]
                                  (list (map try_parse_number (.split (get val 1)))))))
           (if args.query
               (print_table (eval_query args.query table))
               (print_table table))))

(main)
