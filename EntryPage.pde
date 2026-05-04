// EntryPage.pde

void showMenuPage() {
  background(245, 240, 230);
  fill(40, 60, 120);
  textAlign(CENTER, CENTER);
  textSize(36);
  //text("Knowledge or Boom!", width/2, 220); // -> 改成圖片?
  
  drawButton("開始遊戲", width/2 - 80, 360, 160, 55);
  drawButton("說明",     width/2 - 80, 435, 160, 55);
  drawButton("關於我們", width/2 - 80, 510, 160, 55);
}

void handleMenuClick() {
  if (isInButton(mouseX, mouseY, width/2 - 80, 360, 160, 55)) {
    initBoard(); CallScreenID = 2;
  }
  if (isInButton(mouseX, mouseY, width/2 - 80, 435, 160, 55)) {
    CallScreenID = 7;
  }
  if (isInButton(mouseX, mouseY, width/2 - 80, 510, 160, 55)) {
    CallScreenID = 6;
  }
}
