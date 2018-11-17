## best-ca-project-eva
# Music box with OLEG and rotary encoder

Here you can see our project files:

* **Music box** (without comments) (_for real men_): [here](https://github.com/noteisenheim/best-ca-project-eva/blob/master/musec.v)

* **Music box** (with comments): [here](https://github.com/noteisenheim/best-ca-project-eva/blob/master/musec2.v)

  Clk is bounded to the clock generator of a board.
  
  Rb is bounded to a button on a board.
  
  If the button is not pressed then everything return to an initial state. Otherwise, the melody plays twice and stops.
  
  Notes are played sequentially. The variable cur shows what note is being played right now. We determine the frequency using tone_value and create square waves using clock divider. 


* **Rotary encoder** (without comments) (_for real men_): [here](https://github.com/noteisenheim/best-ca-project-eva/blob/master/rotary_encoder.v)

* **Simplified rotary encoder** (with comments): [here](https://github.com/noteisenheim/best-ca-project-eva/blob/master/simple_rotary_encoder.v)

* **Rotary encoder** (with comments): [here](https://github.com/noteisenheim/best-ca-project-eva/blob/master/rotary_encoder2.v)

  dt and sw are bounded to the output of the rotary encoder. On each clockwise rotation counter is increased, on counterclockwise - decreased. Then number of rotations is converted to rotation angle
  
      (angle = (number of rotations mod 20) * 18)
  Output is to the 8-segment display
  
  (Also, there may be some inaccuracy in responses of a rotary encoder)

* **Interaction with ps/2 keyboard** (with comments): [here](https://github.com/noteisenheim/best-ca-project-eva/blob/master/help.v)

  There was a problem with ps/2 input on FPGA bord (it just does not work ¯\\___(ツ)___/¯), so we couldn't test that code, but it is supposed to work. 
  You can read more about interaction with ps/2 keyboard [here](http://www.eecg.toronto.edu/~jayar/ece241_08F/AudioVideoCores/ps2/ps2.html).
