#!/usr/bin/env nbb

(ns tsx-extract-styles
  (:require [clojure.string :as str]
            ["fs" :as fs]))

(defn extract-obj-styles
  [s]
  (let [matches
        (re-seq #"[sS]tyle={({[\w\W]*?})}" s)]
    (map #(str/trim (second %)) matches)))

(extract-obj-styles "style={{color:'red', fontSize: 16, margin: 10}}
                    style={{color: 'blue', fontSize: 18, margin: 20}}")


(defn extract-arr-styles
  [s]
  (let [matches (re-seq #"[sS]tyle={\[([\w\W]*?)\]}" s)]
    (map #(second %) matches)))

(extract-arr-styles "titleStyle={[
                     {color:'red', fontSize: 16, margin: 10}, {color: 'blue', fontSize: 18, margin: 20}
                     ]}")


(defn split-arr-styles-idx
  "split 
  '{ flexDirection: 'row', backgroundColor: '#F5F6F7', borderRadius: 2, paddingVertical: 15 }, props.style'
  to [{xxx}, props.style]"
  [s]
  (loop [idx 0
         res []
         depth 0]
    (if (>= idx (count s))
      res
      (let [c (get s idx)]
        (cond
          (and (= c \,) (zero? depth))
          (recur (inc idx) (conj res idx) depth)

          (= c \{)
          (recur (inc idx) res (inc depth))

          (= c \})
          (recur (inc idx) res (dec depth))

          :else
          (recur (inc idx) res depth))))))

(defn split-str-by-idxs [s idxs]
  (let [ranges (partition 2 1 (concat [0] idxs [(count s)]))]
    (map (fn [[start end]] (subs s start end)) ranges)))

(defn split-arr-style [s]
  (let [idxes (split-arr-styles-idx s)
        styles-with-comma (split-str-by-idxs s idxes)]
    (map (fn [s]
           (str/trim
            (if (= \, (first s))
              (subs s 1)
              s))) styles-with-comma)))

(defn timestamp []
  (js/Date.now))

(defn gen-names [len]
  (let [now (timestamp)
        arr (range len)]
    (map #(str "rename_" now "_" %) arr)))

(defn extract-styles [s]
  (let [obj-styles
        (extract-obj-styles s)

        aar-styles
        (flatten (map #(split-arr-style %) (extract-arr-styles s)))

        all-styles
        (filter #(and (str/starts-with? % "{")
                      (str/ends-with? % "}")
                      (not (str/index-of % "// no extract")))

                (concat obj-styles aar-styles))

        names (gen-names (count all-styles))

        replaced-s (reduce (fn [s [old new]] (str/replace s old (str "styles." new))) s (map vector all-styles names))

        new-styles-str (str/join (map (fn [n s] (str n ": " s ",\n")) names all-styles))

        create-styles-pos  (str/index-of replaced-s "const styles = StyleSheet.create({")

        replaced-and-inserted-s
        (if create-styles-pos
          (let [insert-pos (+ create-styles-pos (count "const styles = StyleSheet.create({"))]
            (str (subs replaced-s 0 insert-pos)
                 new-styles-str
                 (subs replaced-s insert-pos)))
          (str replaced-s "\nconst styles = StyleSheet.create({\n" new-styles-str "\n});"))]
    replaced-and-inserted-s))


(def file (first *command-line-args*))

(if (not file) (println "Please specify a file")
    (->>
     (fs/readFileSync file "utf-8")
     (extract-styles)
     (fs/writeFileSync file)))
