// Declaration.pde
void showDeclaration() {
  background(245, 240, 230);
  fill(50);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("聲明頁（待補）", width/2, height/2);
  drawButton("返回主選單", width/2 - 80, 770, 160, 45);
  // 填入版權聲明、免責聲明等內容
}
void handleDeclarationClick() {
  if (isInButton(mouseX, mouseY, width/2 - 80, 770, 160, 45)) CallScreenID = 1;
}
