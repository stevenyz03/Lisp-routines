;|
;;By Steven Xu
;;-------------------------=={ relays }==--------------------------;;
	renames layouts in sequence 
	This is the third lisp of the 4 part lisp of drawing set up
;;----------------------------------------------------------------------;;
	Version 1.0 - 2023 Mar 10th 
	- First version of the routine 
	- Requires the command to be ran multiple times if there are different disciplines
	- For example if you need M-1.01 up to M-3.05 you will have to run this command 3 times, each time 
	- with different prefixes, first one being M-1. second one being M-2. third one being M-3. etc
	- This can be flexible with whatever style layout name you need, as you can customize prefix
	- suffix, starting number, number of digits etc.
|;
(defun c:relays ( / idx lst lyc obj pre srt suf num digits laylen )
   (vlax-for lay (setq lyc (vla-get-layouts (vla-get-activedocument (vlax-get-acad-object))))
       (if (= :vlax-false (vla-get-modeltype lay))
           (setq lst (cons (vla-get-name     lay) lst)
                 srt (cons (vla-get-taborder lay) srt)
                 obj (cons lay obj)
           )
       )
   )
   (if (setq
	laylen (strlen (itoa (length (layoutlist))))
	pre (getstring t "\nSpecify prefix <none>: ")
	suf (getstring T "\nSpecify suffix <None>: ")
	digits (cond ((getint (strcat "\nSpecify number of digits <" (itoa laylen) ">: ")))(laylen))
	num (1- (cond ((getint "\nSpecify starting number <1>: "))(1)))
	srt (vl-sort-i srt '<)
	obj (mapcar '(lambda ( n ) (nth n obj)) srt)
	idx (LM:listbox "Select Layouts to Rename" (mapcar '(lambda ( n ) (nth n lst)) srt) 3)
       )
       (progn
           ;; Temporary rename to free up keys held by other layouts in the selection
           (foreach n idx (vla-put-name (nth n obj) (vla-get-handle (nth n obj))))
           (foreach n idx (vla-put-name (nth n obj) (getname lyc pre suf num digits)))
       )
   )
   (princ)
)
(defun getname ( lyc pre suf int digits / int rtn )

(defun pad (m / padded) ; fill out with preceding 0's as appropriate
	(setq padded (itoa m))
	(while (< (strlen padded) digits)
		(setq padded (strcat "0" padded))
	); while
	padded ; return to main routine
); defun -- pad

   (while
       (not
           (vl-catch-all-error-p
               (vl-catch-all-apply 'vla-item
                   (list lyc
                       (setq int (1+ int)
                             rtn (strcat pre (pad int)suf)
                       )
                   )
               )
           )
       )
   )
   rtn
)

;; List Box  -  Lee Mac
;; Displays a DCL list box allowing the user to make a selection from the supplied data.
;; msg - [str] Dialog label
;; lst - [lst] List of strings to display
;; bit - [int] 1=allow multiple; 2=return indexes
;; Returns: [lst] List of selected items/indexes, else nil

(defun LM:listbox ( msg lst bit / dch des tmp rtn )
   (cond
       (   (not
               (and
                   (setq tmp (vl-filename-mktemp nil nil ".dcl"))
                   (setq des (open tmp "w"))
                   (write-line
                       (strcat "listbox:dialog{label=\"" msg "\";spacer;:list_box{key=\"list\";multiple_select="
                           (if (= 1 (logand 1 bit)) "true" "false") ";width=50;height=15;}spacer;ok_cancel;}"
                       )
                       des
                   )
                   (not (close des))
                   (< 0 (setq dch (load_dialog tmp)))
                   (new_dialog "listbox" dch)
               )
           )
           (prompt "\nError Loading List Box Dialog.")
       )
       (   t     
           (start_list "list")
           (foreach itm lst (add_list itm))
           (end_list)
           (setq rtn (set_tile "list" "0"))
           (action_tile "list" "(setq rtn $value)")
           (setq rtn
               (if (= 1 (start_dialog))
                   (if (= 2 (logand 2 bit))
                       (read (strcat "(" rtn ")"))
                       (mapcar '(lambda ( x ) (nth x lst)) (read (strcat "(" rtn ")")))
                   )
               )
           )
       )
   )
   (if (< 0 dch)
       (unload_dialog dch)
   )
   (if (and tmp (setq tmp (findfile tmp)))
       (vl-file-delete tmp)
   )
   rtn
)

(vl-load-com) (princ)