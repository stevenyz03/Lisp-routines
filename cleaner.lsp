(defun c:cleaner ( / LayLst drawing )
	(command "_.CHPROP" "all" "" "_color" "ByLAyer" "")
	(command "_.-layer" "lock" "A-Arch,A-Arch-Hatch,A-ArchU,A-Ceiling,A-Demo,A-Electrical,A-Elevations,A-Exist,A-FireSeparation,A-Furniture,A-Future,A-Grid,A-Structural,G-Text,G-Notes (No Plot),P-Fixtures" "")
	(setq drawing (ssget "x"))
	(command "_.chprop" drawing "" "la" "A-Arch" "")
	(command "_.-layer" "unlock" "A-Arch,A-Arch-Hatch,A-ArchU,A-Ceiling,A-Demo,A-Electrical,A-Elevations,A-Exist,A-FireSeparation,A-Furniture,A-Future,A-Grid,A-Structural,G-Text,G-Notes (No Plot),P-Fixtures" "")
)



;|
(defun c:laysoff ( / LayLst)
  (setq LayLst (list "A-Arch" "A-Arch-Hatch" "A-ArchU" "A-Ceiling" "A-Demo" "A-Electrical" "A-Elevations" "A-Exist" "A-FireSeparation" "A-Furniture" "A-Future" "A-Grid" "A-Structural" "G-Text" "G-Notes (No Plot)" "P-Fixtures"))
  (vlax-for % (cd:ACX_Layers)
    (if (member (vla-get-name %) LayLst)
      (vla-put-layeron % :vlax-false)
    )
  )
  (princ)
)
(defun c:layson ( / LayLst)
  (setq LayLst (list "A-Arch" "A-Arch-Hatch" "A-ArchU" "A-Ceiling" "A-Demo" "A-Electrical" "A-Elevations" "A-Exist" "A-FireSeparation" "A-Furniture" "A-Future" "A-Grid" "A-Structural" "G-Text" "G-Notes (No Plot)" "P-Fixtures"))
  (vlax-for % (cd:ACX_Layers)
    (if (member (vla-get-name %) LayLst)
      (vla-put-layeron % :vlax-true)
    )
  )
  (princ)
)
(defun cd:ACX_ADoc ()
  (or
    *cd-ActiveDocument*
    (setq *cd-ActiveDocument*
      (vla-get-ActiveDocument (vlax-get-acad-object))
    )
  )
  *cd-ActiveDocument*
)
(defun cd:ACX_Layers ()
  (or
    *cd-Layers*
    (setq *cd-Layers* (vla-get-Layers (cd:ACX_ADoc)))
  )
  *cd-Layers*
)







;|(defun c:cleaner (/ excludedlayers filterlist ss lay)
  (setq excludedlayers '("A-Arch" "A-Arch-Hatch" "A-ArchU" "A-Ceiling" "A-Demo" "A-Electrical" "A-Elevations" "A-Exist" "A-FireSeparation" "A-Furniture" "A-Future" "A-Grid" "A-Structural" "G-Text" "G-Notes (No Plot)" "P-Fixtures"))

  (setq filterlist '((0 . "*")
                     (-4 . "<NOT>")
                     (-4 . "<AND>")
                    )
  )

  (foreach exlayer excludedlayers
    (setq filterlist (append filterlist `((0 . "LAYER")(2 . ,exlayer))))
  )
  
  (setq filterlist (append filterlist '(-4 . "AND>")))

  (setq ss (ssget "_X" filterlist))
  
  (setq lay "A-Arch")
  (command "_chprop" ss "" "_LA" lay "")
)
