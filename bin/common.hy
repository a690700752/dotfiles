(import json)

(defn empty? [x] (if x False True))
(defn first [x] (if x (get x 0) None))
(defn last [x] (if x (get x -1) None))

(defn print_json [x] (print (json.dumps x)))

