
console.log('Content script loaded');

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
	if (request.action === 'showToast') {
		try {
			showToast(request.message);
			sendResponse({ success: true });
		} catch (error) {
			console.error('Toast error:', error);
			sendResponse({ success: false, error: error.message });
		}
	}
	return true; // Keep the message channel open for async response
});

function showToast(message) {
	// Check if we can access the document
	if (!document || !document.body) {
		throw new Error('Document or body not accessible');
	}
	
	// Remove any existing toasts
	const existingToasts = document.querySelectorAll('.nicecopy-toast');
	existingToasts.forEach(toast => toast.remove());
	
	const toast = document.createElement('div');
	toast.className = 'nicecopy-toast'; // Add a class for easier management
	
	const icon = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#00ff80" 
	  stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-circle-check-big">
	  <path stroke="#00ff80" d="M21.801 10A10 10 0 1 1 17 3.335"/>
	  <path stroke="#00ff80" d="m9 11 3 3L22 4"/>
	  </svg>`;
	
	toast.innerHTML = icon;
	const textNode = document.createTextNode(message);
	toast.appendChild(textNode);
	
	// Use CSS custom properties for easier maintenance
	document.documentElement.style.setProperty('--nicecopy-toast-zindex', '2147483646');
	
	toast.style.cssText = `
  position: fixed !important;
  font-family:-apple-system,BlinkMacSystemFont,'Segoe UI Variable','Segoe UI',system-ui,ui-sans-serif,Helvetica,Arial,sans-serif,'Apple Color Emoji','Segoe UI Emoji' !important;
  font-size: 14px !important;
  font-weight: 600 !important;
  -webkit-font-smoothing:antialiased !important;
  color: #fff !important;
  display: flex !important;
  align-items: center !important;
  gap: 0.5em !important;
  top: 20px !important;
  right: 20px !important;
  background: linear-gradient(to right, hsl(0, 0%, 20%), hsl(0, 0%, 15%)) !important;
  padding: .8em .8em .8em .8em !important;
  box-shadow: 5px 5px 20px 3px rgba(0, 0, 0, 0.4) !important;
  border-radius: 1.5em !important;
  -webkit-border-radius: 1.5em !important;
  line-height: 1 !important;
  z-index: 2147483647 !important;
  opacity: 1 !important;
  transition: opacity 0.3s ease-in-out !important;
  pointer-events: none !important;
  border: none !important;
`;
	
	// Use requestAnimationFrame for smoother rendering
	requestAnimationFrame(() => {
		document.body.appendChild(toast);
		
		const removeToast = () => {
			if (document.body.contains(toast)) {
				toast.style.opacity = '0';
				setTimeout(() => {
					if (document.body.contains(toast)) {
						document.body.removeChild(toast);
					}
				}, 300);
			}
		};
		
		setTimeout(removeToast, 3000);
	});
}

