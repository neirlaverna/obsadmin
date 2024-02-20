function allowPermission() {
  Notification.requestPermission((status) => {
      alert(status);
  });
}

window.state = {
  title: '',
  body: '',
  icon: '',
  counter:0,
}

// create and show the notification
function showNotification() {
  window.state.counter ++;
  // create a new notification
  const notification = new Notification(window.state.title, {
    body: window.state.body,
    icon: window.state.icon,
  });

  // close the notification after 10 seconds
  setTimeout(() => {
    notification.close();
  }, 10 * 1000);

  // increment state counter
  notification.addEventListener("click", () => {
    alert('You click this notification');
  });

}