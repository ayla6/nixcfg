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
  num (tap-hold 180 180 f (layer-toggle numbers))
  sym (layer-toggle symbols)
  nav (layer-toggle navigation)
  bas (layer-switch base)

  ;; mouse movement
  mlf (movemouse-accel-left 10 500 1 5)
  mrt (movemouse-accel-right 10 500 1 5)
  mup (movemouse-accel-up 10 500 1 5)
  mdn (movemouse-accel-down 10 500 1 5)

  ;; mouse wheel
  mwu (mwheel-up 10 10)
  mwd (mwheel-down 10 10)
  mwl (mwheel-left 10 10)
  mwr (mwheel-right 10 10)

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
  pl S-9
  pr S-0
  : S-;
  cl ;
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
         1    2    3    4    5    6    =    7    8    9    0    -
         
  tab    q    w    @num p    b    [    j    l    u    y    @cl  esc
                                            
  @nav   a    r    s    t    g    ]    m    n    e    i    o    '
         
  lsft   z   x    c    d    v  \  /   k    h    ,    .    ret
    
  lctl   @sym spc  lalt ralt
)

(deflayer symbols
          _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    @!   @@   @#   @%   @~   XX   `    @&   @|   @?   @:   _

     _    @+   =    [    @pl  @^   XX   @*   @{   @_   @cl  -    @qt
 
_    _    _    \    ]    @pr     XX XX  /    @}   @<   @>   _
      
     _    _    _    _    _
)

(deflayer navigation
          _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    _    _    _    _    _    XX   _    home pgdn pgup end  _
          
     _    _    lalt lsft lctl _    XX   ret  left down up   @rgt del
 
     _    _    _    _    esc  _  XX XX  bspc _    _    _    _
      
     _    _    _    _    _
)

(deflayer numbers
          _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    _    _    _    _    _    XX   =    7    8    9    @+   _
          
     _    _    _    _    _    _    XX   /    1    2    3    -    \
 
     _    _    _    _    _    _  XX XX  @*   4    5    6    _
      
     _    _    0    _    _
)

(deflayer empty
          _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    _    _    _    _    _    XX   _    _    _    _    _    _
 
     _    _    _    _    _    _  XX XX  _    _    _    _    _
      
     _    _    _    _    _
)
