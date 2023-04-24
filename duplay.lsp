;|
;;By Steven Xu
;;-------------------------=={ duplay }==--------------------------;;
	duplicates the specified numbers of layouts 
	This is the second lisp of the 4 part lisp of drawing set up
;;----------------------------------------------------------------------;;
	Version 1.0 - 2023 Mar 10th 
	- First version of the routine 
	- Requires the command to be ran after the title block is setup, or else title block has to
	  be inserted everytime
	- Working on combining vpcopy,duplay,and relays into one as I might be able to automate layout
	  copy and renaming without user input using the variables from vpcopy. For example if we have 5 sheets
	  for fire, 6 for plumbing, and 5 for HVAC, they are stored in a global variable used by duplay through 
	  summing the sheet numbers and copying that many layouts. And use individual discipline sheet numbers
	  to generate layout names.
|;
(defun c:duplayout ( / CTAB LAYOUT# LAYOUTNAME )
     (setvar "cmdecho" 0)
     (setq ctab "M-1.01")
     (setq layoutname (getstring (strcat "\nLayout to duplicate <" ctab ">: ")))
     (if (= layoutname "") (setq layoutname ctab))
     (initget 6)
     (setq layout# (getint "\nHow many copies ?<2>: "))
     (if (null layout#) (setq layout# 2))
     (repeat layout#
          (command ".layout" "copy" layoutname "")
);repeat
(princ)
);defun