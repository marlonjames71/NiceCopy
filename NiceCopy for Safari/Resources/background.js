
console.log('Background script loaded');

// GET TAB URL

async function getCurrentTabUrl() {
	try {
		const tabs = await browser.tabs.query({ active: true, currentWindow: true });
		if (tabs.length > 0) {
			const currentUrl = tabs[0].url;
			console.log('Current tab URL:', currentUrl);
			sendUrlToNativeApp(currentUrl);
		} else {
			console.error('No active tab found.');
		}
	} catch (error) {
		console.error('Error querying tabs:', error);
	}
}

// SEND URL TO APP

function sendUrlToNativeApp(url) {
	const message = {
		action: 'sendUrl',
		url: url
	};
	
	browser.runtime.sendNativeMessage('NiceCopy for Safari', message)
		.then(response => {
			console.log('Response from native app:', response);
			
			if (response.status === "Copied Current URL") {
				sendMessageToContentScript(response.status);
			}
		})
		.catch(error => {
			console.error('Error sending message to native app:', error);
		});
}


// USER ACTIONS

browser.action.onClicked.addListener(() => {
	getCurrentTabUrl();
});

browser.commands.onCommand.addListener((command) => {
	if (command === "copy-url") {
		getCurrentTabUrl();
	}
});

// SEND MESSAGE TO CONTENT.JS

function sendMessageToContentScript(status) {
	browser.tabs.query({ active: true, currentWindow: true }).then((tabs) => {
		if (tabs.length > 0) {
			browser.tabs.sendMessage(tabs[0].id, { action: 'showToast', message: status });
		}
	});
}
