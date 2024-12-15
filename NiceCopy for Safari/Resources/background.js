console.log("Background script loaded");

// GET TAB URL

async function getCurrentTabUrl() {
   try {
      const tabs = await browser.tabs.query({
         active: true,
         currentWindow: true,
      });
      if (tabs.length > 0) {
         const currentUrl = tabs[0].url;
         console.log("Current tab URL:", currentUrl);
         sendUrlToNativeApp(currentUrl);
      } else {
         console.error("No active tab found.");
      }
   } catch (error) {
      console.error("Error querying tabs:", error);
   }
}

// SEND URL TO APP

function onCopyURLResponse(response) {
   console.log(`Copy URL Response Received: ${response}`);

   if (response.status === "Copied URL") {
      sendMessageToContentScript(response.status);
   }
}

function onCopyURLError(error) {
   console.log(`Copy URL Error: ${error}`);
}

function sendUrlToNativeApp(url) {
   const message = {
      action: "sendUrl",
      url: url,
   };

   let sending = browser.runtime.sendNativeMessage(
      "NiceCopy for Safari",
      message
   );
   sending.then(onCopyURLResponse, onCopyURLError);
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

// CONTEXT MENUS

// Create context menus function
function createContextMenus() {
   // Remove existing menus first to avoid duplicates
   browser.contextMenus
      .removeAll()
      .then(() => {
         browser.contextMenus.create({
            id: "context_menu-copy_url",
            title: "Copy Page URL",
            contexts: ["page"],
         });

         browser.contextMenus.create({
            id: "context_menu-open_app",
            title: "Open NiceCopy App",
            contexts: ["action"],
         });
      })
      .catch((error) => {
         console.error("Error creating context menus:", error);
      });
}

// Create menus when extension starts
createContextMenus();

// Also create menus on installation (optional, but good practice)
browser.runtime.onInstalled.addListener(createContextMenus);

function onOpenAppResponse(response) {
   console.log(`Open App Received: ${response}`);
}

function onOpenAppError(error) {
   console.log(`Open App Error: ${error}`);
}

browser.contextMenus.onClicked.addListener((info, tab) => {
   if (info.menuItemId === "context_menu-copy_url") {
      getCurrentTabUrl();
   }

   const message = { action: "openApp" };

   if (info.menuItemId === "context_menu-open_app") {
      let sending = browser.runtime.sendNativeMessage(
         "NiceCopy for Safari",
         message
      );
      sending.then(onOpenAppResponse, onOpenAppError);
   }
});

// SEND MESSAGE TO CONTENT.JS

function sendMessageToContentScript(status) {
   browser.tabs.query({ active: true, currentWindow: true }).then((tabs) => {
      if (tabs.length > 0) {
         browser.tabs.sendMessage(tabs[0].id, {
            action: "showToast",
            message: status,
         });
      }
   });
}
