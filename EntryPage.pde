// EntryPage.pde

void showMenuPage() {
  background(245, 240, 230);
  fill(40, 60, 120);
  textAlign(CENTER, CENTER);
  textSize(36);
  //text("Knowledge or Boom!", width/2, 220); // -> 改成圖片?
  
  drawButton("開始遊戲", width/2 - 80, 340, 160, 55);
  drawButton("說明",     width/2 - 80, 410, 160, 55);
  drawButton("關於我們", width/2 - 80, 480, 160, 55);
  drawButton("聲明",     width/2 - 80, 550, 160, 55);
}

void handleMenuClick() {
  if (isInButton(mouseX, mouseY, width/2 - 80, 340, 160, 55)) {
    initBoard(); CallScreenID = 2;
  }
  if (isInButton(mouseX, mouseY, width/2 - 80, 410, 160, 55)) {
    CallScreenID = 7;
  }
  if (isInButton(mouseX, mouseY, width/2 - 80, 480, 160, 55)) {
    CallScreenID = 6;
  }
  if (isInButton(mouseX, mouseY, width/2 - 80, 550, 160, 55)) {
    CallScreenID = 8;
  }
}
