
console.log('Content script loaded');

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
	if (request.action === 'showToast') {
		showToast(request.message);
	}
});


//function showToast(message) {
//	const toast = document.createElement('div');
//	const icon = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" 
//stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-circle-check-big">
// <path stroke="currentColor" d="M21.801 10A10 10 0 1 1 17 3.335"/>
// <path stroke="currentColor" d="m9 11 3 3L22 4"/>
//</svg>`;
//	toast.innerHTML = icon
//	toast.textContent = message;
//	toast.style.cssText = `
//	position: fixed;
//	display: flex;
//	align-items: center;
//	gap: 0.5em;
//	top: 20px;
//	right: 20px;
//	background: linear-gradient(to right, hsl(0, 0%, %), hsl(0, 0%, 15%));
//	color: #fff;
//	padding: 15px 20px;
//	box-shadow: 5px 5px 20px 3px rgba(0, 0, 0, 0.4);
//	border-radius: 0.7em;
//	line-height: 1;
//	z-index: 9999;
//	transition: opacity 0.3s ease-in-out;
//		`;
//	document.body.appendChild(toast);
//	setTimeout(() => {
//		toast.style.opacity = '0';
//		setTimeout(() => {
//			document.body.removeChild(toast);
//		}, 300);
//	}, 3000);
//}

function showToast(message) {
	const toast = document.createElement('div');
	const icon = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#00ff80" 
	 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-circle-check-big">
	 <path stroke="#00ff80" d="M21.801 10A10 10 0 1 1 17 3.335"/>
	 <path stroke="#00ff80" d="m9 11 3 3L22 4"/>
	 </svg>`;
	
	// Set the inner HTML to include the icon
	toast.innerHTML = icon;
	
	// Create a text node for the message
	const textNode = document.createTextNode(message);
	
	// Append the text node to the toast element
	toast.appendChild(textNode);
	
	// Set the styles for the toast
	toast.style.cssText = `
		  position: fixed;
		  font-family: system-ui !important;
		  font-size: 16px !important;
		  display: flex;
		  align-items: center;
		  gap: 0.5em;
		  top: 20px;
		  right: 20px;
		  background: linear-gradient(to right, hsl(0, 0%, 25%), hsl(0, 0%, 15%));
		  color: #fff;
		  padding: .8em 1.2em .8em .8em;
		  box-shadow: 5px 5px 20px 3px rgba(0, 0, 0, 0.4);
		  border-radius: 0.7em;
		  line-height: 1;
		  z-index: 9999;
		  opacity: 1;
		  transition: opacity 0.3s ease-in-out;
	 `;
	
	// Append the toast to the body
	document.body.appendChild(toast);
	
	// Set a timeout to fade out and remove the toast
	setTimeout(() => {
		toast.style.opacity = '0';
		setTimeout(() => {
			document.body.removeChild(toast);
		}, 300);
	}, 3000);
}

