
console.log('Content script loaded');

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
	if (request.action === 'showToast') {
		showToast(request.message);
	}
});

function showToast(message) {
	const toast = document.createElement('div');
	const icon = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#00ff80" 
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
		  position: fixed !important;
		  font-family:-apple-system,BlinkMacSystemFont,'Segoe UI Variable','Segoe UI',system-ui,ui-sans-serif,Helvetica,Arial,sans-serif,'Apple Color Emoji','Segoe UI Emoji' !important;
		  font-size: 14px !important;
		  font-weight: 600 !important; 
		  -webkit-font-smoothing:antialiased !important;
		  color: #fff !important;
		  display: flex;
		  align-items: center !important;
		  gap: 0.5em;
		  top: 20px !important;
		  right: 20px !important;
		  background: linear-gradient(to right, hsl(0, 0%, 20%), hsl(0, 0%, 15%)) !important;
		  padding: .8em .8em .8em .8em !important;
		  box-shadow: 5px 5px 20px 3px rgba(0, 0, 0, 0.4) !important;
		  border-radius: 1.5em !important;
		  line-height: 1 !important;
		  z-index:2147483646 !important;
		  opacity: 1 !important;
		  transition: opacity 0.3s ease-in-out !important;
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

