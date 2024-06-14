#!/usr/bin/env nbb

(ns tsx-extract-styles
  (:require [clojure.string :as str]
            ["fs" :as fs]))

(defn str-index-of-any [s any offset]
  (loop [i offset]
    (if (< i (count s))
      (if (str/includes? any (nth s i))
        i
        (recur (inc i)))
      nil)))

(str-index-of-any "he)l(lo" "()" 3)
;; => 4


(defn find-nested-pair [s pair offset]
  (let [open? (fn [c] (= c (nth pair 0)))
        close? (fn [c] (= c (nth pair 1)))
        open-idx (str/index-of s (nth pair 0) offset)]
    (if (nil? open-idx) nil
        (loop [i open-idx cnt 0]
          (let [idx (str-index-of-any s pair i)]
            (cond (and idx (open? (nth s idx))) (recur (inc idx) (inc cnt))
                  (and idx (close? (nth s idx))) (cond
                                                   (= cnt 1) [open-idx idx]
                                                   (> cnt 1) (recur (inc idx) (dec cnt))
                                                   :else (recur (inc idx) cnt))
                  :else nil))))))


(find-nested-pair "12)34 () 1234 " "()" 0)
;; => [6 7]


(defn find-styles [s]
  (->> (re-seq #"[Ss]tyle={({[\w\W]*?})}" s)
       (filterv #(not (str/index-of (second %) "// no extract")))))

(find-styles "style={{margin: 9}}")
;; => (["style={{margin: 9}}" "{margin: 9}"])
(find-styles "style={{margin: 9}} style={{// no extract \nmargin: 8}}")

(defn find-create-styles [s]
  (let [start-idx (str/index-of s "const styles = StyleSheet.create")]
    (if start-idx
      (let [pair-idxes
            (find-nested-pair s "()" start-idx)]
        (if pair-idxes
          [start-idx (if (and
                          (< (inc (second pair-idxes)) (count s))
                          (= ";" (nth s (inc (second pair-idxes)))))
                       (+ 2 (second pair-idxes))
                       (inc (second pair-idxes)))]
          nil))
      nil)))

(find-create-styles "const styles = StyleSheet.create({})")
;; => [0 36]


(defn split-code-and-create-styles [s]
  (let [create-styles-block (find-create-styles s)]
    (if create-styles-block
      [(str
        (subs s 0 (first create-styles-block))
        (subs s (second create-styles-block)))
       (subs s (first create-styles-block) (second create-styles-block))]
      [s "const styles = StyleSheet.create({})"])))

(split-code-and-create-styles "a b c const styles = StyleSheet.create({});")
;; => ["a b c " "const styles = StyleSheet.create({});"]

(split-code-and-create-styles "a b c const styles = StyleSheet.create({}); d e f")
;; => ["a b c  d e f" "const styles = StyleSheet.create({});"]

(defn str-insert-by-ancher [s ancher insert]
  (str (subs s 0 ancher) insert (subs s ancher)))

(str-insert-by-ancher "abc" 2 "def")

(defn gen_random_names [cnt]
  (let [now (js/Date.now)]
    (map #(str "rename_" now "_" %) (range cnt))))

(gen_random_names 5)


(defn main [s]
  (let [[code create-styles] (split-code-and-create-styles s)
        styles (find-styles code)
        names (gen_random_names (count styles))]
    (str
     (reduce-kv #(str/replace %1 (nth %3 1) (str "styles." (nth names %2))) code styles)
     (str-insert-by-ancher create-styles
                           (+ 2
                              (str/index-of create-styles "({"))
                           (str/join ""
                                     (map-indexed (fn [idx item]
                                                    (str (nth names idx)
                                                         ": "
                                                         (second item)
                                                         ",")) styles))))))

(main "style={{margin: 7}} style={{ margin: 8}} b c const styles = StyleSheet.create({content: {margin: 1}})")


(def file (first *command-line-args*))

(if (not file) (println "Please specify a file")
    (->>
     (fs/readFileSync file "utf-8")
     (main)
     (fs/writeFileSync file)))
