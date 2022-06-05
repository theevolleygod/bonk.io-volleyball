// this is just miscellaneous usage of volleyball things

// draw volley ball lines : (GameGraphics.as:1882)
private function drawVolleyballLines(param1:Array) : *
{
    this._volleyballLines = new Sprite();
    this._gameplay.addChild(this._volleyballLines);
    this._volleyballLines.graphics.lineStyle(0,13027014,0.15,true);
    this._volleyballLines.graphics.moveTo(Main.$logW / 2,param1[1].borderThickness);
    this._volleyballLines.graphics.lineTo(Main.$logW / 2,Main.$logH - param1[1].borderThickness - param1[1].netHeight);
    this._volleyballLines.graphics.lineStyle(undefined);
    this._volleyballLines.graphics.beginFill(13027014,0.15);
    this._volleyballLines.graphics.moveTo(Main.$logW / 2 - param1[1].borderThickness / 2,Main.$logH - param1[1].borderThickness);
    this._volleyballLines.graphics.lineTo(Main.$logW / 2 - param1[1].borderThickness / 2,Main.$logH - param1[1].borderThickness - param1[1].netHeight);
    this._volleyballLines.graphics.lineTo(Main.$logW / 2 + param1[1].borderThickness / 2,Main.$logH - param1[1].borderThickness - param1[1].netHeight);
    this._volleyballLines.graphics.lineTo(Main.$logW / 2 + param1[1].borderThickness / 2,Main.$logH - param1[1].borderThickness);
    this._volleyballLines.graphics.lineTo(Main.$logW / 2 - param1[1].borderThickness / 2,Main.$logH - param1[1].borderThickness);
    this._volleyballLines.graphics.endFill();
}

