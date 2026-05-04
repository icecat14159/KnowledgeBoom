// Manual.pde

void showManual() {
  background(245, 240, 230);
  fill(50);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("說明頁（寫遊戲玩法和規則）", width/2, height/2);
  drawButton("返回主選單", width/2 - 80, 770, 160, 45);

}
void handleManualClick() {
  if (isInButton(mouseX, mouseY, width/2 - 80, 770, 160, 45)) CallScreenID = 1;
}
