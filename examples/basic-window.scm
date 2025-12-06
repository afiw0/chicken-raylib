(import raylib)


(init-window 800 450 "raylib [core] example - basic window")

(let loop ()
  (with-drawing
   (lambda ()
     (clear-background color/raywhite)
     (draw-text "Congrats! You created your first window!"
                190
                200
                20
                color/light-gray)))
  (unless (window-should-close?)
    (loop)))

(close-window)
