angle=$3
  ratio=`convert $1 -format \
     "%[fx:aa=45*pi/180; min(w,h)/(w*abs(sin(aa))+h*abs(cos(aa)))]" \
     info:`
  crop="%[fx:floor(w*$ratio)]x%[fx:floor(h*$ratio)]"
  crop="$crop+%[fx:ceil((w-w*$ratio)/2)]+%[fx:ceil((h-h*$ratio)/2)]"
  convert $1 -set option:distort:viewport "$crop" \
          +distort SRT $angle +repage $2
