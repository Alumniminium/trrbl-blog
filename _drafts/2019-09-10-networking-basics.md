---
layout: post
title: networking basics #1
slug: networking-basics-1
tags: networking linux
author: Trrbl
excerpt: 
permalink: /usr/bin/:slug.html
image: https://cdn.her.st/images/0353a08e-581c-482e-a439-dbf3c42e788c.webp
thumbnail: https://cdn.her.st/images/3b9c290b-692c-413b-80b6-e6b766761976.webp
---



# How does IP work

First you need to enter your IP here


<center>
  <input id="input" type="text" placeholder="enter your ip" />
  <button id="replaceIpButton">click to update the article with your IP</button>
</center>


# now you can connect to http://[router-ip]/

<script>
function replaceInText(element, pattern, replacement) {
  for (let node of element.childNodes) {
      switch (node.nodeType) {
          case Node.ELEMENT_NODE:
              replaceInText(node, pattern, replacement);
              break;
          case Node.TEXT_NODE:
              node.textContent = node.textContent.replace(pattern, replacement);
              break;
      }
  }
}
const btn = document.getElementById('replaceIpButton');
btn.addEventListener('click', function () {
  const element = document.getElementById('post-id');
  const ip = document.getElementById('input').value;
  replaceInText(element,'[router-ip]', ip);
});
</script>