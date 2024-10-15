
console.log('Content script loaded');

//browser.runtime.onMessage.addListener(async (request, sender, sendResponse) => {
//	if (request.action === 'copyToClipboard') {
//		try {
//			console.log('Received message to copy URL:', request.url);
//			const blob = new Blob([request.url], { type: 'text/plain' });
//			const clipboardItem = new ClipboardItem({ 'text/plain': blob });
//			await navigator.clipboard.write([clipboardItem]);
//			console.log('URL copied to clipboard successfully');
//			showToast("Copied Current URL");
//		} catch (error) {
//			console.error('Failed to copy URL to clipboard:', error);
//			showToast("Couldn't copy URL");
//		}
//	}
//});

browser.runtime.onMessage.addListener(async (request, sender, sendResponse) => {
	if (request.action === 'copyToClipboard') {
//		try {
			console.log('Received message to copy URL:', request.url);
			
//			// Check for ClipboardItem support
//			if (typeof ClipboardItem !== 'undefined' && navigator.clipboard.write) {
//				const blob = new Blob([request.url], { type: 'text/plain' });
//				const clipboardItem = new ClipboardItem({ 'text/plain': blob });
//				if (navigator.userActivation.isActive) {
//					console.log('Has transient activation.');
//				} else if (navigator.userActivation.hasBeenActive) {
//					console.log('Transient has been active.');
//				} else {
//					console.log('URL NOT copied. Something to do with transient activation timer running out.');
//				}
//				await navigator.clipboard.write([clipboardItem]);
//				console.log('URL copied to clipboard successfully');
//			} else {
//				// Fallback for browsers that don't support ClipboardItem
//				await navigator.clipboard.writeText(request.url);
//				console.log('URL copied to clipboard using writeText');
//			}
			
			showToast("Copied Current URL");
//		} catch (error) {
//			console.error('Failed to copy URL to clipboard:', error);
//			showToast("Couldn't copy URL");
//		}
	}
});


function showToast(message) {
	const toast = document.createElement('div');
	toast.textContent = message;
	toast.style.cssText = `
				position: fixed;
				bottom: 20px;
				left: 50%;
				transform: translateX(-50%);
				background-color: #333;
				color: #fff;
				padding: 10px 20px;
				border-radius: 5px;
				z-index: 9999;
				transition: opacity 0.3s ease-in-out;
		`;
	document.body.appendChild(toast);
	setTimeout(() => {
		toast.style.opacity = '0';
		setTimeout(() => {
			document.body.removeChild(toast);
		}, 300);
	}, 3000);
}
