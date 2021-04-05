function	setup()
{
	createCanvas(720, 720, SVG);
}

function	draw()
{
	background(220);
	ellipse(0, 0, 50);
	if (frameCount > 100) {
        noLoop();
        save();
    }
}