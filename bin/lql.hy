#!/usr/bin/env hy

(import prettytable [PrettyTable])
(import argparse [ArgumentParser])
(import sys)

(setv builtin-filter filter)

(defn try-parse-number [s]
    (try
        (if (in "." s) 
            (float s) 
            (int s))
        (except [ValueError]
            s))
)

(defn pad-arr [arr n val]
    (if (< (len arr) n)
        (+ arr (* [val] (- n (len arr))))
        arr))
        
(defn empty? [arr]
    (= (len arr) 0))

(defn print-table [table]
    (if (empty? table) None
    (let [x (PrettyTable)
        max-len (max (map (fn [row] (len row)) table))
    ] 
        (setv x.field_names (range max-len)) 
        (for [row table]
            (.add_row x (pad-arr row max-len ""))
        )
        (print x)))
)

(defn main [] 
    (defmacro filter [func iter]
        `(builtin-filter (fn [it] ~func) ~iter))
        
    (defn construct-query [in]
        (+ "(" in " table)"))
    
    (let [parser (ArgumentParser)]

        (.add_argument parser "query" :nargs "?")
        (setv args (.parse_args parser))
        (setv table [])
        (for [val (enumerate sys.stdin)] 
            (.append table (+ [(get val 0)]
            (list (map try-parse-number (.split (get val 1))))
                                )))
        (if args.query 
            (print-table (list (hy.eval (hy.read (construct-query args.query)) :macros (local-macros))))
            (print-table table))
    )
)

(main)
