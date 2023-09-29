# create dir structure
mkdir 1
mkdir 2
# get initial input image (o.png)
#wget "https://0xf.at$(curl  https://0xf.at/play/30 --silent| grep " <img src" | grep -Po '\"\K[^"]*' | grep -o '^\S*')" -O o.png -q
# clean up image for processing (overwriting o.png)
convert o.png -normalize  -auto-level o.png
# split images into each letter
convert o.png -crop 6x5@ 1/tile-%d.png
# get image mean brightness
#
for f in 1/*.png; do
	cp "$f" "2/$(identify -format "%[fx:mean.g ]\n" $f | awk '{print $1 * 1000000}')"
done

# reasemble image
convert $(ls -vr 2/*) +append  full_img.png
convert -colorspace gray -contrast-stretch 1x0%  -lat 10x10+5% -negate -auto-level full_img.png out.png
rm full_img.png




gocr out.png | sed s/'\s'//g

#cleanup
rm -Rvf 2/ 1> /dev/null
rm -Rvf 1/ 1> /dev/null
rm o.png 1> /dev/null
rm out.png 1> /dev/null
