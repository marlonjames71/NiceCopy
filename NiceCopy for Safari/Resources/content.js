console.log('Content script loaded');

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
	if (!request || typeof request.action !== 'string') {
		sendResponse({ success: false, error: 'Invalid request format' });
		return true;
	}
	
	if (request.action === 'showToast') {
		try {
			showToast(request.message || 'Success');
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
	
	try {
		const existingContainer = document.getElementById('nice-copy-toast-container-2024');
		if (existingContainer) {
			existingContainer.remove();
		}
		
		const container = document.createElement('div');
		container.id = 'nice-copy-toast-container-2024';
		Object.assign(container.style, {
			position: 'fixed',
			top: '0',
			left: '0',
			width: '100%',
			height: '100%',
			pointerEvents: 'none',
			zIndex: '2147483647',
			all: 'initial'
		});
		
		const toast = document.createElement('div');
		toast.setAttribute('role', 'status');
		Object.assign(toast.style, {
			position: 'fixed',
			top: '20px',
			right: '20px',
			display: 'flex',
			alignItems: 'center',
			gap: '0.5em',
			padding: '0.8em',
			fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI Variable", "Segoe UI", system-ui, ui-sans-serif, Helvetica',
			fontSize: '14px',
			fontWeight: '600',
			color: '#ffffff',
			background: 'linear-gradient(to right, hsla(0, 0%, 20%, 0.95), hsla(0, 0%, 15%, 0.95))',
			borderRadius: '1.5em',
			boxShadow: '5px 5px 20px 3px rgba(0, 0, 0, 0.4)',
			opacity: '0',
			transform: 'scale(0.8) translateY(-20px)',
			transition: 'all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55)',
			zIndex: '2147483647',
			webkitFontSmoothing: 'antialiased',
			transformOrigin: 'top center'
		});
		
		const icon = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#00ff80" 
				stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
				<path stroke="#00ff80" d="M21.801 10A10 10 0 1 1 17 3.335"/>
				<path stroke="#00ff80" d="m9 11 3 3L22 4"/>
				</svg>`;
		
		const iconContainer = document.createElement('span');
		iconContainer.innerHTML = icon;
		toast.appendChild(iconContainer);
		
		const textNode = document.createTextNode(message);
		toast.appendChild(textNode);
		
		container.appendChild(toast);
		document.body.appendChild(container);
		
		void toast.offsetWidth;
		
		requestAnimationFrame(() => {
			Object.assign(toast.style, {
				opacity: '1',
				transform: 'scale(1) translateY(0)'
			});
			
			setTimeout(() => {
				Object.assign(toast.style, {
					opacity: '0',
					transform: 'scale(0.8) translateY(-20px)'
				});
				
				setTimeout(() => {
					if (container.parentNode) {
						container.parentNode.removeChild(container);
					}
				}, 300);
			}, 3000);
		});
		
	} catch (error) {
		console.error('Toast creation error:', error);
		throw error;
	}
}
