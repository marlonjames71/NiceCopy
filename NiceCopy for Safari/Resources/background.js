
console.log('Background script loaded');

//async function copyCurrentTabUrl() {
//	let tabs;
//	try {
//		tabs = await browser.tabs.query({active: true, currentWindow: true});
//	} catch (error) {
//		console.error('Error querying tabs:', error);
//		return; // Exit the function if an error occurs
//	}
//	
//	if (tabs.length > 0) {
//		const url = tabs[0].url;
//		console.log('Sending message to content script with URL:', url);
//		sendMessageToTab(tabs[0].id, url);
//	} else {
//		console.error('No active tab found.');
//	}
//}

//browser.action.onClicked.addListener(() => {
//	copyCurrentTabUrl();
//});
//
//browser.commands.onCommand.addListener((command) => {
//	if (command === "copy-url") {
//		copyCurrentTabUrl();
//	}
//});

browser.browserAction.onClicked.addListener(async () => {
	const tab = await browser.tabs.getCurrent()
	navigator.clipboard.writeText(tab.url)
//	sendMessageToTab(tab.id, tab.url)
})

//browser.commands.onCommand.addListener((command) => {
//	switch(command) {
//		case "copy-url":
//			browser.tabs.getCurrent().then((tab) => {
//				navigator.clipboard.writeText(tab.url)
//				sendMessageToTab(tab.id, tab.url)
//			})
//	}
//})

//function sendMessageToTab(tabId, url) {
//	browser.tabs.sendMessage(tabId, {action: 'copyToClipboard', url: url}).catch(error => {
//		console.error('Error sending message to tab:', error);
//	});
//}
