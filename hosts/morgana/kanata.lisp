(defsrc
       1 2 3 4 5 6 7 8 9 0 - =
  tab  q w e r t y u i o p [ ]
  caps a s d f g h j k l ; ' \
  lsgt z x c v b n m , . /
  lalt spc lsft lctl
)

(defalias
  ;; shortenings
  bsp bspc

  ;; shortcuts
  cut C-x
  cpy C-c
  pst C-v
  und C-z
  red C-S-z
  all C-a

  ;; change modes
  sym (tap-hold-release 200 200 spc (layer-toggle symbols))
  bsnv (tap-hold-release 200 200 bspc (layer-toggle navigation))
  nav (layer-switch navigation)
  mse (layer-switch mouse)
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
)

(deflayer base
         1    2    3    4    5    6    =    7    8    9    0    -
         
  tab    q    w    f    p    b    [    j    l    u    y    @cl  esc
                                            
  @bsnv  a    r    s    t    g    ]    m    n    e    i    o    '
         
     z   x    c    d    v    \    /    k    h    ,    .
    
  lalt   @sym lsft lctl
)

(deflayer symbols
          _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    @@   @#   @*   @_   @+   XX   @^   =    -    @&   @%   @$
          
     _    @:   @cl  @pl  @pr  ret  XX   _    S-[  S-]  [    ]    S-'
 
     lctl _    @mse @nav esc  S-/  XX   S-\  @!    S-,  S-.
 
     _    _    _    _
)

(deflayer navigation
          _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    @all @pst @cpy @cut @und XX   _    left down up   rght _  
 
     _    _    _    del  _    @red XX        end  pgdn pgup home
      
  lalt    @bas _    _
)

(deflayer mouse
          _    _    _    _    _    XX   _    _    _    _    _    _
          
     _    _    _    _    _    _    XX   @red @pst @cpy @cut @und _
          
     _    _    mmid mrgt mlft _    XX   _    @mlf @mdn @mup @mrt _  
 
     _    _    _    _    _    _    XX        @mwl @mwd @mwu @mwr
      
     _    @bas _    _
)
