(module raylib *

(import (scheme)
        (chicken base)
        (chicken foreign)
        (foreigners)
        (srfi-4))

(foreign-declare "#include <raylib.h>")

(foreign-declare
 "Color ToColor (unsigned char *x) { return (Color) {x[0], x[1], x[2], x[3]}; }
  Rectangle ToRectangle (float *x) { return (Rectangle) {x[0], x[1], x[2], x[3]}; }
  Vector2 ToVector2 (float *x) { return (Vector2) {x[0], x[1]}; }
  void FromVector2 (float *x, Vector2 v) { x[0]=v.x; x[1]=v.y; }
  Vector3 ToVector3 (float *x) { return (Vector3) {x[0], x[1], x[2]}; }
  void FromVector3 (float *x, Vector3 v) { x[0]=v.x; x[1]=v.y; x[2]=v.z; }")

(define-foreign-type Color u8vector)
(define (make-color r g b a)
  (u8vector r g b a))

(define-foreign-type Rectangle f32vector)
(define (make-rect x y w h)
  (f32vector x y w h))
(define (rect-x r) (f32vector-ref r 0))
(define (rect-y r) (f32vector-ref r 1))
(define (rect-w r) (f32vector-ref r 2))
(define (rect-h r) (f32vector-ref r 3))

(define-foreign-type Vector2 f32vector)
(define (make-vec2 x y)
  (f32vector x y))
(define (vec2-x v) (f32vector-ref v 0))
(define (vec2-y v) (f32vector-ref v 1))

(define-foreign-type Vector3 f32vector)
(define (make-vec3 x y z)
  (f32vector x y z))
(define (vec3-x v) (f32vector-ref v 0))
(define (vec3-y v) (f32vector-ref v 1))
(define (vec3-z v) (f32vector-ref v 2))

(define-foreign-record-type (Texture* "struct Texture")
  (constructor: make-texture)
  (destructor: free-texture) 
  (unsigned-int id texture-id)
  (int width texture-width)
  (int height texture-height)
  (int mipmaps texture-mipmaps)
  (int format texture-format))

(define-foreign-record-type (Camera2D* "struct Camera2D")
  (constructor: make-camera2d)
  (destructor: free-camera2d)
  (float rotation camera2d-rotation camera2d-rotation-set!)
  (float zoom camera2d-zoom camera2d-zoom-set!))
(define camera2d-offset-helper
  (foreign-lambda* void ((Vector2 out) (Camera2D* camera)) "FromVector2(out, camera->offset);"))
(define camera2d-target-helper
  (foreign-lambda* void ((Vector2 out) (Camera2D* camera)) "FromVector2(out, camera->target);"))
(define camera2d-offset-set!
  (foreign-lambda* void ((Camera2D* camera) (Vector2 v)) "camera->offset = ToVector2(v);"))
(define camera2d-target-set!
  (foreign-lambda* void ((Camera2D* camera) (Vector2 v)) "camera->target = ToVector2(v);"))
(define (camera2d-offset camera)
  (let ([out (make-vec2 0 0)])
    (camera2d-offset-helper out camera)
    out))
(define (camera2d-target camera)
  (let ([out (make-vec2 0 0)])
    (camera2d-target-helper out camera)
    out))

(define-foreign-record-type (Camera3D* "struct Camera3D")
  (constructor: make-camera3d)
  (destructor: free-camera3d)
  (float fovy camera3d-fovy camera3d-fovy-set!)
  (int projection camera3d-projection camera3d-projection-set!))
(define camera3d-position-helper
  (foreign-lambda* void ((Vector3 out) (Camera3D* camera)) "FromVector3(out, camera->position);"))
(define camera3d-target-helper
  (foreign-lambda* void ((Vector3 out) (Camera3D* camera)) "FromVector3(out, camera->target);"))
(define camera3d-up-helper
  (foreign-lambda* void ((Vector3 out) (Camera3D* camera)) "FromVector3(out, camera->up);"))
(define camera3d-position-set!
  (foreign-lambda* void ((Camera3D* camera) (Vector3 v)) "camera->position = ToVector3(v);"))
(define camera3d-target-set!
  (foreign-lambda* void ((Camera3D* camera) (Vector3 v)) "camera->target = ToVector3(v);"))
(define camera3d-up-set!
  (foreign-lambda* void ((Camera3D* camera) (Vector3 v)) "camera->up = ToVector3(v);"))
(define (camera3d-position camera)
  (let ([out (make-vec3 0 0 0)])
    (camera3d-position-helper out camera)
    out))
(define (camera3d-target camera)
  (let ([out (make-vec3 0 0 0)])
    (camera3d-position-helper out camera)
    out))
(define (camera3d-up camera)
  (let ([out (make-vec3 0 0 0)])
    (camera3d-position-helper out camera)
    out))


(define color/light-gray  (make-color 200 200 200 255))
(define color/gray        (make-color 130 130 130 255))
(define color/dark-gray   (make-color 80  80  80  255))
(define color/yellow      (make-color 253 249 0   255))
(define color/gold        (make-color 255 203 0   255))
(define color/orange      (make-color 255 161 0   255))
(define color/pink        (make-color 255 109 194 255))
(define color/red         (make-color 230 41  55  255))
(define color/maroon      (make-color 190 33  55  255))
(define color/green       (make-color 0   228 48  255))
(define color/lime        (make-color 0   158 47  255))
(define color/dark-green  (make-color 0   117 44  255))
(define color/sky-blue    (make-color 102 191 255 255))
(define color/blue        (make-color 0   121 241 255))
(define color/dark-blue   (make-color 0   82  172 255))
(define color/purple      (make-color 200 122 255 255))
(define color/violet      (make-color 135 60  190 255))
(define color/dark-purple (make-color 112 31  126 255))
(define color/beige       (make-color 211 176 131 255))
(define color/brown       (make-color 127 106 79  255))
(define color/dark-brown  (make-color 76  63  47  255))
(define color/white       (make-color 255 255 255 255))
(define color/black       (make-color 0   0   0   255))
(define color/blank       (make-color 0   0   0   0  ))
(define color/magenta     (make-color 255 0   255 255))
(define color/raywhite    (make-color 245 245 245 255))

(define log/all     0)
(define log/trace   1)
(define log/debug   2)
(define log/info    3)
(define log/warning 4)
(define log/error   5)
(define log/fatal   6)
(define log/none    7)

(define key/null             0   )      ; key: null, used for no key pressed
(define key/apostrophe       39  )      ; key: '
(define key/comma            44  )      ; key: ,
(define key/minus            45  )      ; key: -
(define key/period           46  )      ; key: .
(define key/slash            47  )      ; key: /
(define key/zero             48  )      ; key: 0
(define key/one              49  )      ; key: 1
(define key/two              50  )      ; key: 2
(define key/three            51  )      ; key: 3
(define key/four             52  )      ; key: 4
(define key/five             53  )      ; key: 5
(define key/six              54  )      ; key: 6
(define key/seven            55  )      ; key: 7
(define key/eight            56  )      ; key: 8
(define key/nine             57  )      ; key: 9
(define key/semicolon        59  )      ; key: ;
(define key/equal            61  )      ; key: =
(define key/a                65  )      ; key: a | a
(define key/b                66  )      ; key: b | b
(define key/c                67  )      ; key: c | c
(define key/d                68  )      ; key: d | d
(define key/e                69  )      ; key: e | e
(define key/f                70  )      ; key: f | f
(define key/g                71  )      ; key: g | g
(define key/h                72  )      ; key: h | h
(define key/i                73  )      ; key: i | i
(define key/j                74  )      ; key: j | j
(define key/k                75  )      ; key: k | k
(define key/l                76  )      ; key: l | l
(define key/m                77  )      ; key: m | m
(define key/n                78  )      ; key: n | n
(define key/o                79  )      ; key: o | o
(define key/p                80  )      ; key: p | p
(define key/q                81  )      ; key: q | q
(define key/r                82  )      ; key: r | r
(define key/s                83  )      ; key: s | s
(define key/t                84  )      ; key: t | t
(define key/u                85  )      ; key: u | u
(define key/v                86  )      ; key: v | v
(define key/w                87  )      ; key: w | w
(define key/x                88  )      ; key: x | x
(define key/y                89  )      ; key: y | y
(define key/z                90  )      ; key: z | z
(define key/left-bracket     91  )      ; key: [
(define key/backslash        92  )      ; key: '\'
(define key/right-bracket    93  )      ; key: ]
(define key/grave            96  )      ; key: `
(define key/space            32  )      ; key: space
(define key/escape           256 )      ; key: esc
(define key/enter            257 )      ; key: enter
(define key/tab              258 )      ; key: tab
(define key/backspace        259 )      ; key: backspace
(define key/insert           260 )      ; key: ins
(define key/delete           261 )      ; key: del
(define key/right            262 )      ; key: cursor right
(define key/left             263 )      ; key: cursor left
(define key/down             264 )      ; key: cursor down
(define key/up               265 )      ; key: cursor up
(define key/page-up          266 )      ; key: page up
(define key/page-down        267 )      ; key: page down
(define key/home             268 )      ; key: home
(define key/end              269 )      ; key: end
(define key/caps-lock        280 )      ; key: caps lock
(define key/scroll-lock      281 )      ; key: scroll down
(define key/num-lock         282 )      ; key: num lock
(define key/print-screen     283 )      ; key: print screen
(define key/pause            284 )      ; key: pause
(define key/f1               290 )      ; key: f1
(define key/f2               291 )      ; key: f2
(define key/f3               292 )      ; key: f3
(define key/f4               293 )      ; key: f4
(define key/f5               294 )      ; key: f5
(define key/f6               295 )      ; key: f6
(define key/f7               296 )      ; key: f7
(define key/f8               297 )      ; key: f8
(define key/f9               298 )      ; key: f9
(define key/f10              299 )      ; key: f10
(define key/f11              300 )      ; key: f11
(define key/f12              301 )      ; key: f12
(define key/left-shift       340 )      ; key: shift left
(define key/left-control     341 )      ; key: control left
(define key/left-alt         342 )      ; key: alt left
(define key/left-super       343 )      ; key: super left
(define key/right-shift      344 )      ; key: shift right
(define key/right-control    345 )      ; key: control right
(define key/right-alt        346 )      ; key: alt right
(define key/right-super      347 )      ; key: super right
(define key/kb-menu          348 )      ; key: kb menu
(define key/kp-0             320 )      ; key: keypad 0
(define key/kp-1             321 )      ; key: keypad 1
(define key/kp-2             322 )      ; key: keypad 2
(define key/kp-3             323 )      ; key: keypad 3
(define key/kp-4             324 )      ; key: keypad 4
(define key/kp-5             325 )      ; key: keypad 5
(define key/kp-6             326 )      ; key: keypad 6
(define key/kp-7             327 )      ; key: keypad 7
(define key/kp-8             328 )      ; key: keypad 8
(define key/kp-9             329 )      ; key: keypad 9
(define key/kp-decimal       330 )      ; key: keypad .
(define key/kp-divide        331 )      ; key: keypad /
(define key/kp-multiply      332 )      ; key: keypad *
(define key/kp-subtract      333 )      ; key: keypad -
(define key/kp-add           334 )      ; key: keypad +
(define key/kp-enter         335 )      ; key: keypad enter
(define key/kp-equal         336 )      ; key: keypad =
(define key/back             4   )      ; key: android back button
(define key/menu             5   )      ; key: android menu button
(define key/volume-up        24  )      ; key: android volume up button
(define key/volume-down      25  )      ; key: android volume down button

(define mouse-button/left    0)
(define mouse-button/right   1)
(define mouse-button/middle  2)
(define mouse-button/side    3)
(define mouse-button/extra   4)
(define mouse-button/forward 5)
(define mouse-button/back    6)

;; Window-related functions
(define init-window (foreign-lambda void "InitWindow" int int c-string))
(define close-window (foreign-lambda void "CloseWindow"))
(define get-screen-width (foreign-lambda int "GetScreenWidth"))
(define get-screen-height (foreign-lambda int "GetScreenHeight"))
(define window-should-close? (foreign-lambda bool "WindowShouldClose"))

;; Drawing-related functions
(define begin-drawing (foreign-lambda void "BeginDrawing"))
(define end-drawing (foreign-lambda void "EndDrawing"))
(define begin-mode-2d 
  (foreign-lambda* void ((Camera2D* camera)) "BeginMode2D(*camera);"))
(define end-mode-2d (foreign-lambda void "EndMode2D"))
(define begin-mode-3d
  (foreign-lambda* void ((Camera3D* camera)) "BeginMode3D(*camera);"))
(define end-mode-3d (foreign-lambda void "EndMode3D"))
(define clear-background 
  (foreign-lambda* void ((Color c)) "ClearBackground(ToColor(c));"))

;; Timing-related functions
(define set-target-fps (foreign-lambda void "SetTargetFPS" int))
(define get-frame-time (foreign-lambda float "GetFrameTime"))
(define get-time (foreign-lambda double "GetTime"))
(define get-fps (foreign-lambda int "GetFPS"))

;; Input-related functions: keyboard
(define key-pressed? (foreign-lambda bool "IsKeyPressed" int))
(define key-pressed-repeat? (foreign-lambda bool "IsKeyPressedRepeat" int))
(define key-down? (foreign-lambda bool "IsKeyDown" int))
(define key-released? (foreign-lambda bool "IsKeyReleased" int))
(define key-up? (foreign-lambda bool "IsKeyUp" int))
(define get-key-pressed (foreign-lambda int "GetKeyPressed"))
(define get-char-pressed (foreign-lambda int "GetCharPressed"))

;; Input-related functions:  mouse
(define mouse-button-pressed? (foreign-lambda bool "IsMouseButtonPressed" int))
(define mouse-button-down? (foreign-lambda bool "IsMouseButtonDown" int))
(define mouse-button-released? (foreign-lambda bool "IsMouseButtonReleased" int))
(define mouse-button-up? (foreign-lambda bool "IsMouseButtonUp" int))
(define get-mouse-x (foreign-lambda int "GetMouseX"))
(define get-mouse-y (foreign-lambda int "GetMouseY"))
(define (get-mouse-position)
  (make-vec2 (get-mouse-x) (get-mouse-y)))

;; Misc. functions
(define trace-log 
  (foreign-lambda* void ((int logLevel) (c-string text)) "TraceLog(logLevel, text);"))

;; File system functions
(define change-directory (foreign-lambda bool "ChangeDirectory" c-string))

;; Texture loading functions
(define load-texture-helper
  (foreign-lambda* void ((Texture* out) (c-string filename)) "*out = LoadTexture(filename);"))
(define (load-texture filename)
  (let ([texture (make-texture)])
    (load-texture-helper texture filename)
    texture))

;; Basic shapes drawing functions
(define draw-pixel 
  (foreign-lambda* void ((int posX) (int posY) (Color color)) "DrawPixel(posX, posY, ToColor(color));"))
(define draw-pixel-v
  (foreign-lambda* void ((Vector2 position) (Color color)) "DrawPixelV(ToVector2(position), ToColor(color));"))

(define draw-line 
  (foreign-lambda* void ((int startPosX) (int startPosY) (int endPosX) (int endPosY) (Color color)) 
                   "DrawLine(startPosX, startPosY, endPosX, endPosY, ToColor(color));"))
(define draw-line-v
  (foreign-lambda* void ((Vector2 startPos) (Vector2 endPos) (Color color)) 
                   "DrawLineV(ToVector2(startPos), ToVector2(endPos), ToColor(color));"))
(define draw-line-ex
  (foreign-lambda* void ((Vector2 startPos) (Vector2 endPos) (float thick) (Color color)) 
                   "DrawLineEx(ToVector2(startPos), ToVector2(endPos), thick, ToColor(color));"))

(define draw-circle
  (foreign-lambda* void ((int centerX) (int centerY) (float radius) (Color color)) 
                   "DrawCircle(centerX, centerY, radius, ToColor(color));"))
(define draw-circle-v
  (foreign-lambda* void ((Vector2 center) (float radius) (Color color)) 
                   "DrawCircleV(ToVector2(center), radius, ToColor(color));"))
(define draw-circle-lines
  (foreign-lambda* void ((int centerX) (int centerY) (float radius) (Color color)) 
                   "DrawCircleLines(centerX, centerY, radius, ToColor(color));"))
(define draw-circle-lines-v
  (foreign-lambda* void ((Vector2 center) (float radius) (Color color)) 
                   "DrawCircleLinesV(ToVector2(center), radius, ToColor(color));"))


(define draw-rectangle
  (foreign-lambda* void ((int posX) (int posY) (int width) (int height) (Color color)) 
                   "DrawRectangle(posX, posY, width, height, ToColor(color));"))
(define draw-rectangle-v
  (foreign-lambda* void ((Vector2 position) (Vector2 size) (Color color)) 
                   "DrawRectangleV(ToVector2(position), ToVector2(size), ToColor(color));"))
(define draw-rectangle-rec
  (foreign-lambda* void ((Rectangle rec) (Color color)) 
                   "DrawRectangleRec(ToRectangle(rec), ToColor(color));"))
(define draw-rectangle-pro
  (foreign-lambda* void ((Rectangle rec) (Vector2 origin) (float rotation) (Color color)) 
                   "DrawRectanglePro(ToRectangle(rec), ToVector2(origin), rotation, ToColor(color));"))
(define draw-rectangle-lines
  (foreign-lambda* void ((int posX) (int posY) (int width) (int height) (Color color)) 
                   "DrawRectangleLines(posX, posY, width, height, ToColor(color));"))
(define draw-rectangle-lines-ex
  (foreign-lambda* void ((Rectangle rec) (float lineThick) (Color color)) 
                   "DrawRectangleLinesEx(ToRectangle(rec), lineThick, ToColor(color));"))

(define draw-triangle
  (foreign-lambda* void ((Vector2 v1) (Vector2 v2) (Vector2 v3) (Color color)) 
                   "DrawTriangle(ToVector2(v1), ToVector2(v2), ToVector2(v3), ToColor(color));"))
(define draw-triangle-lines
  (foreign-lambda* void ((Vector2 v1) (Vector2 v2) (Vector2 v3) (Color color)) 
                   "DrawTriangleLines(ToVector2(v1), ToVector2(v2), ToVector2(v3), ToColor(color));"))

;; Texture drawing functions
(define draw-texture 
  (foreign-lambda* void ((Texture* texture) (int posX) (int posY) (Color tint)) 
                   "DrawTexture(*texture, posX, posY, ToColor(tint));"))
(define draw-texture-v
  (foreign-lambda* void ((Texture* texture) (Vector2 position) (Color tint)) 
                   "DrawTextureV(*texture, ToVector2(position), ToColor(tint));"))
(define draw-texture-ex
  (foreign-lambda* void ((Texture* texture) (Vector2 position) (float rotation) (float scale) (Color tint)) 
                   "DrawTextureEx(*texture, ToVector2(position), rotation, scale, ToColor(tint));"))
(define draw-texture-rec
  (foreign-lambda* void ((Texture* texture) (Rectangle source) (Vector2 position) (Color tint)) 
                   "DrawTextureRec(*texture, ToRectangle(source), ToVector2(position), ToColor(tint));"))
(define draw-texture-pro
  (foreign-lambda* void ((Texture* texture) (Rectangle source) (Rectangle dest) (Vector2 origin) (float rotation) (Color tint)) 
                   "DrawTexturePro(*texture, ToRectangle(source), ToRectangle(dest), ToVector2(origin), rotation, ToColor(tint));"))

;; Text drawing functions
(define draw-text 
  (foreign-lambda* 
    void ((c-string text) (int posX) (int posY) (int fontSize) (Color c)) 
    "DrawText(text, posX, posY, fontSize, ToColor(c));"))

(define measure-text (foreign-lambda int "MeasureText" c-string int))

;; Scheme wrappers not present in original API

(define-syntax %define-wrappers
  (syntax-rules ()
    ((_ procedure-name init fini additional-params ...)
     (define (procedure-name additional-params ... thunk)
       (init additional-params ...)
       (let ((res (thunk)))
         (fini)
         res)))))

;; Admittedly I'm not sure how useful this one is, but I'm adding it for symmetry
(%define-wrappers with-window init-window close-window w h title)

(%define-wrappers with-drawing begin-drawing end-drawing)

(%define-wrappers with-mode-2d begin-mode-2d end-mode-2d camera)

(%define-wrappers with-mode-3d begin-mode-3d end-mode-3d camera)

) ;; end of module
