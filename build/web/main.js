function setImageSource(imageId, url) {
  const img = document.getElementById(imageId);
  img.src = url;
}

function toggleFullscreen(imageId) {
  const img = document.getElementById(imageId);
  if (img.requestFullscreen) {
    img.requestFullscreen();
  } else if (img.mozRequestFullScreen) {
    img.mozRequestFullScreen();
  } else if (img.webkitRequestFullscreen) {
    img.webkitRequestFullscreen();
  } else if (img.msRequestFullscreen) {
    img.msRequestFullscreen();
  }
}
