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
  sym (layer-while-held symbols)
  nav (layer-while-held navigation)
  
  game (layer-switch game)
  base (layer-switch base)

  spl (tap-hold 200 200 spc (layer-while-held modn))

  ha (tap-hold-press 200 150 a lmet)
  hr (tap-hold-press 200 150 r lalt)
  hs (tap-hold-press 200 150 s lsft)
  ht (tap-hold-press 200 150 t lctl)
  hn (tap-hold-press 200 150 n rctl)
  he (tap-hold-press 200 150 e rsft)
  hi (tap-hold-press 200 150 i lalt)
  ho (tap-hold-press 200 150 o rmet)
  
  3q (tap-dance 200 (3 q))
  2w (tap-dance 200 (2 w))
  1f (tap-dance 200 (1 f))
  0p (tap-dance 200 (0 p))
  5l (tap-dance 200 (5 l))
  6u (tap-dance 200 (6 u))
  4y (tap-dance 200 (4 y))

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

  lctl   lalt @spl @sym ralt
)

(deflayer symbols
          _    _    _    _    _    XX   _    _    _    _    _    _

     _    @%   @!   @+   [    @@   XX   @#   ]    @_   @?   @^   _

     @nav /    @:   =    @{   @$   XX   \    @}   @qt  @sc  -    @~

     _    @#   `    @*   @po  @& XX XX  @|   @pc  @<   @>   _

     _    _    _    _    _
)

(deflayer modn
          _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    @3q  @2w  @1f  @0p  _    XX   _    @5l  @6u  @4y  9    _

     @nav @ha  @hr  @hs  @ht  ret  XX   ret  @hn  @he  @hi  @ho  _

     _    _    _    _    _    8  XX XX  7    _    _    _    _

     _    _    _    _    _
)

(deflayer navigation
          _    _    _    _    _    XX   _    _    _    _    _    _

     _    _    _    pgup _    _    XX   _    _    ret  del  _    _

     XX   _    home pgdn end  _    XX   ret  left down up   @rgt del

     _    _    _    _    esc  esc XX XX bspc bspc _    _    _

     _    _    _    _    _
)

(deflayer game
          _    _    _    _    _    XX   _    _    _    _    _    _

     _    t    q    w    e    r    XX   _    _    _    _    _    _

     @nav g    a    s    d    f  @base  _    _    _    _    _    _

     _    d    z    x    c    v  XX XX  _    _    _    _    _

     _    _    spc  _    _
)

(deflayer empty
          _    _    _    _    _    XX   _    _    _    _    _    _

     _    _    _    _    _    _    XX   _    _    _    _    _    _

     @nav _    _    _    _    _    XX   _    _    _    _    _    _

     _    _    _    _    _    _  XX XX  _    _    _    _    _

     _    _    _    _    _
)
