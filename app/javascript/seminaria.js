document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll(".actions-button").forEach( (i) => {
    i.addEventListener("click", function() {
      y = i.nextElementSibling;
      if (y.style.display === "none") { y.style.display = "block"; } else { y.style.display = "none"; }
    });
  });
});
