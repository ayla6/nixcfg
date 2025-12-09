(defsrc
       1 2 3 4 5 6 7 8 9 0 - =
  tab  q w e r t y u i o p [ ]
  caps a s d f g h j k l ; ' \
  lsft lsgt z x c v b n m , . / rsft
  lctl lalt spc ralt            menu
)

(defalias
  ;; shortenings
  rgt right

  ;; change modes
  sym (layer-toggle symbols)
  nav (layer-toggle navigation)
  num (layer-toggle numbers)
  
  game (layer-switch game)
  base (layer-switch base)

  ;; mouse movement
  ;; mlf (movemouse-accel-left 10 500 1 5)
  ;; mrt (movemouse-accel-right 10 500 1 5)
  ;; mup (movemouse-accel-up 10 500 1 5)
  ;; mdn (movemouse-accel-down 10 500 1 5)

  ;; mouse wheel
  ;; mwu (mwheel-up 10 10)
  ;; mwd (mwheel-down 10 10)
  ;; mwl (mwheel-left 10 10)
  ;; mwr (mwheel-right 10 10)

  ;; looks more obvious
  ! S-1
  @ S-2
  # S-3
  $ S-4
  % S-5
  ^ S-6
  & S-7
  * S-8
  + S-=
  _ S--
  po S-9
  pc S-0
  : S-;
  sc ;
  { S-[
  } S-]
  | S-\
  ? S-/
  qt S-'
  ~ S-`
  < S-,
  > S-.
)

(deflayer base
         1    2    3    4    5    6    XX   7    8    9    0    -

  tab    q    w    f    p    b    XX   j    l    u    y    @sc  XX

  @nav   a    r    s    t    g  @game  m    n    e    i    o    '

  lsft   z    x    c    d    v  XX XX  k    h    ,    .    rsft

  lctl   lalt spc  @sym ralt
)

(deflayer symbols
          _    _    _    _    _    XX   _    _    _    _    _    _

     _    @%   @!   @+   [    @@   XX   @#   ]    @_   @?   @^   _

     @nav /    @:   =    @{   @$   XX   \    @}   @qt  @sc  -    @~

     _    @#   `    @*   @po  @& XX XX  @|   @pc  @<   @>   _

     _    @num _    _    _
)

;; the devil made kanata so you actually have to hold @sym then hold @num and then release @ralt to be able to use numbers holy shit
(deflayer numbers
          _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    _    _    _    _    _    XX   _    _    _    _    _    _

     @nav 0    1    2    3    .    XX   ,    4    5    6    9    _

     _    _    _    _    8    8  XX XX  7    7    _    _    _

     _    _    _    _    _
)

(deflayer navigation
          _    _    _    _    _    XX   _    _    _    _    _    _

     _    _    C-x  C-c  C-v  _    XX   _    pgdn home end  pgup  _

     XX   _    lalt lsft lctl C-a  XX   ret  left down up   @rgt del

     _    _    _    _    esc  esc XX XX bspc bspc    _    _    _

     _    _    _    _    _
)

(deflayer game
          _    _    _    _    _    XX   _    _    _    _    _    _

     _    t    q    w    e    r    XX   _    _    _    _    _    _

     @nav g    a    s    d    f  @base  _    _    _    _    _    _

     _    d    z    x    c    v  XX XX  _    _    _    _    _

     _    _    _    _    _
)

(deflayer empty
          _    _    _    _    _    XX   _    _    _    _    _    _

     _    _    _    _    _    _    XX   _    _    _    _    _    _

     @nav    _    _    _    _    _    XX   _    _    _    _    _    _

     _    _    _    _    _    _  XX XX  _    _    _    _    _

     _    _    _    _    _
)
