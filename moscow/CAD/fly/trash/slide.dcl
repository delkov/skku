SlideImage : dialog {
key = "title";
label = "Slide from Image";
spacer;
: column {
: image {
alignment = centered;
key = "image1";
width = 50;//100 pixels
height = 10;//100 pixels
fixed_width = true;
fixed_height = true;
aspect_ratio = 1;
color = -15;// -15 = no background, -2 = background
}
}
ok_only;
}