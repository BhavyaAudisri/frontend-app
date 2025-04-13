function updateTime() {
    const timeElement = document.getElementById('current-time');
    timeElement.textContent = new Date().toLocaleTimeString();
}

// Update time every second
setInterval(updateTime, 1000);

// Initial call
updateTime();
