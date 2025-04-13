console.log('Content script loaded');

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
	if (!request || typeof request.action !== 'string') {
		sendResponse({ success: false, error: 'Invalid request format' });
		return true;
	}
	
	if (request.action === 'showToast') {
		try {
			showToast(request.message);
			sendResponse({ success: true });
		} catch (error) {
			console.error('Toast error:', error);
			sendResponse({ success: false, error: error.message });
		}
	}
	return true;
});

function showToast(message) {
	if (!document || !document.body) {
		throw new Error('Document or body not accessible');
	}
	
	const existingToasts = document.querySelectorAll('.nicecopy-toast');
	existingToasts.forEach(toast => toast.remove());
	
	const styleSheet = document.createElement('style');
	styleSheet.textContent = `
		  @keyframes toastIn {
				0% {
					 opacity: 0;
					 transform: scale(0.8) translateY(-20px);
					 backdrop-filter: blur(0px);
				}
				100% {
					 opacity: 1;
					 transform: scale(1) translateY(0);
					 backdrop-filter: blur(8px);
				}
		  }
		  
		  @keyframes toastOut {
				0% {
					 opacity: 1;
					 transform: scale(1) translateY(0);
					 backdrop-filter: blur(8px);
				}
				100% {
					 opacity: 0;
					 transform: scale(0.9) translateY(10px);
					 backdrop-filter: blur(0px);
				}
		  }
		  
		  .nicecopy-toast {
				position: fixed !important;
				font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI Variable', 'Segoe UI', system-ui, ui-sans-serif, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji' !important;
				font-size: 14px !important;
				font-weight: 600 !important;
				-webkit-font-smoothing: antialiased !important;
				color: #fff !important;
				display: flex !important;
				align-items: center !important;
				gap: 0.5em !important;
				top: 20px !important;
				right: 20px !important;
				background: linear-gradient(to right, hsla(0, 0%, 20%, 0.8), hsla(0, 0%, 15%, 0.8)) !important;
				padding: .8em .8em .8em .8em !important;
				box-shadow: 5px 5px 20px 3px rgba(0, 0, 0, 0.4) !important;
				border-radius: 1.5em !important;
				-webkit-border-radius: 1.5em !important;
				line-height: 1 !important;
				z-index: 2147483647 !important;
				pointer-events: none !important;
				border: none !important;
				backdrop-filter: blur(0px) !important;
				-webkit-backdrop-filter: blur(0px) !important;
				opacity: 0;
				transform: scale(0.8) translateY(-20px);
		  }
		  
		  .nicecopy-toast.show {
				animation: toastIn 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55) forwards;
		  }
		  
		  .nicecopy-toast.hide {
				animation: toastOut 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55) forwards;
		  }
	 `;
	document.head.appendChild(styleSheet);
	
	const toast = document.createElement('div');
	toast.className = 'nicecopy-toast';
	
	const icon = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#00ff80" 
		stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-circle-check-big">
		<path stroke="#00ff80" d="M21.801 10A10 10 0 1 1 17 3.335"/>
		<path stroke="#00ff80" d="m9 11 3 3L22 4"/>
		</svg>`;
	
	toast.innerHTML = icon;
	const textNode = document.createTextNode(message);
	toast.appendChild(textNode);
	
	requestAnimationFrame(() => {
		document.body.appendChild(toast);
		
		requestAnimationFrame(() => {
			toast.classList.add('show');
		});
		
		const removeToast = () => {
			if (document.body.contains(toast)) {
				toast.classList.remove('show');
				toast.classList.add('hide');
				
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
