window.addEventListener("message", function (event) {
    const data = event.data;
    const ui = document.getElementById("hex-ui");
    const hex = document.getElementById("hex-container");
    const key = document.getElementById("key");
    const label = document.getElementById("label");

    if (data.action === "show") {
        key.innerText = data.key || "";
        label.innerText = data.text || "";

        ui.style.display = "flex";
        hex.style.display = "flex";

        ui.classList.remove("fade-out");
        hex.classList.remove("fade-out");

        // Force reflow to restart animation
        void ui.offsetWidth;
        void hex.offsetWidth;

        ui.classList.add("fade-in");
        hex.classList.add("fade-in");
    }

    if (data.action === "hide") {
        ui.classList.remove("fade-in");
        hex.classList.remove("fade-in");

        ui.classList.add("fade-out");
        hex.classList.add("fade-out");

        const removeUI = () => {
            ui.style.display = "none";
            ui.classList.remove("fade-out");
            ui.removeEventListener("animationend", removeUI);
        };

        const removeHex = () => {
            hex.style.display = "none";
            hex.classList.remove("fade-out");
            hex.removeEventListener("animationend", removeHex);
        };

        ui.addEventListener("animationend", removeUI);
        hex.addEventListener("animationend", removeHex);
    }
});
