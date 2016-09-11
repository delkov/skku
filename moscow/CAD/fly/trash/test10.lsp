; Ãëàâà 01\Ëèñòèíã 1.12.lsp
; Â êíèãå: Í.Í.Ïîëåùóê, Ï.Â.Ëîñêóòîâ
;"AutoLISP è Visual LISP â ñðåäå AutoCAD"
; (èçäàòåëüñòâî "ÁÕÂ-Ïåòåðáóðã", 2006)
;
; Ëèñòèíã 1.12. Ïðèìåð èñïîëüçîâàíèÿ ôóíêöèé ðàáîòû ñ ôàéëàìè
;
; Îïåðàöèè çàïèñè
(setq ff (open "C:\\Users\\delko_000\\Desktop\\temp.txt" "w"))
(write-line "Ïåðâàÿ ñòðîêà" ff)
(write-char 65 ff)
(write-char 67 ff)
(write-line "Âòîðàÿ ñòðîêà" ff)
(close ff)
; Îïåðàöèè ÷òåíèÿ
(setq ff (open "C:\\Users\\delko_000\\Desktop\\temp.txt" "r"))
(setq s1 (read-char ff))
(setq s2 (read-char ff))
(setq str1 (read-line ff))
(setq str2 (read-line ff))
(setq str3 (read-line ff))
(close ff)
(setq ff nil)
