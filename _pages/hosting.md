---
layout: page
title:  "Fast Affordable Hosting"
author: A Terrible Programmer
permalink: /hosting/
---
# her.st hosting

* Everything is fully KVM virtualized.
* This hosting service is run as a hobby not as a business
* There's no Uptime guarantee or SLA

Total downtime since 01/01/2019: **05h21m47sec** (>99.9% Uptime)

## Last downtimes
* 11/05/2020: Nameserver - **0h09m43sec** - Maintenance work, *.her.st domains didn't resolve during that time, everything else was fine
* 01/07/2020: EVERYTHING - **5h12m04sec** - Power surge, entire Rack in the DC went offline, our PSU didn't survive and got replaced.

**Additional downtimes not explicitly stated / not included in the total downtime:**

Two quarterly node reboots for updates, taking less than 3 minutes each.


# micro plans
Micro plans **share the same public IP** so you will only have **access to a random port range**, if you would like certain ports to be available to you, please tell me before ordering and I'll check if they're available.
Micro plans also **share the same CPU Cores.** You have **no dedicated CPU time** on those plans, so if half of the other clients decide to run an expensive script at 3pm, you will notice a slowdown at 3pm. That being said, at this point in time, even those plans are **faster than what other providers offer** on their completely oversold servers.

Link Speed is 1gbit. Traffic is fair use (i consider 250gb/week fair)

|       	| Micro S 	| Micro M 	| Micro L 	|
|:-----:	|:-------:	|:-------:	|:-------:	|
| CPU   	|  Shared 	|  Shared 	|  Shared 	|
| RAM   	|  256MB  	|  512MB  	|  768MB  	|
| SSD   	|   2GB   	|   4GB   	|   6GB  	|
| IPs   	|   NAT   	|   NAT   	|   NAT   	|
| Monthly   |   2$  	|  3$  	|    4$   	|

# basic plans
Basic plans are where things get interesting: You get **dedicated CPU Cores** and **your very own IP** address! Enjoy.

Link Speed is 1gbit. Traffic is fair use (i consider 500gb/week fair)

|              | Basic S         | Basic M       |  Basic L       | 
|:-------------| :-------------: |:-------------:| :-------------:|
|CPU           | 1               | 2             | 3              |
|RAM| 1 GB | 2 GB      |   3 GB | 
|SSD | 10 GB |15 GB | 20 GB | 
|IPs | 1 | 1  |1|
|Monthly $ | 5$ | 7.50$  | 10$| 

# pro plans
Do you really need this kind of power?

Link Speed is 1gbit. Traffic is fair use (i consider 750gb/week fair)

| | Pro S        | Pro M |
|:-------------| :-------------: |:-------------:| 
|CPU | 4 | 8 |
|RAM| 4 GB | 8 GB | 
|SSD | 30 GB | 60 GB | 
|IPs | 1 | 1  |
|Monthly $ | 15$ | out of stock  |

# How do I order?!
1. Join discord and message me (trbl)
2. Either subscribe using the button below or manually pay every month.

<div  style="padding: 20px 0; display: flex; justify-content: space-evenly; align-items:center"> <iframe src="https://discordapp.com/widget?id=599543436865044513&theme=dark" width="350" height="500" allowtransparency="true" frameborder="0" sandbox="allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts"></iframe>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="437BZV8CNDPZL">
<table>
<tr><td><input type="hidden" name="on0" value="Plans">Plans</td></tr><tr><td><select name="os0">
	<option value="Micro S">Micro S : $2,00 USD - monthly</option>
	<option value="Micro M">Micro M : $3,00 USD - monthly</option>
	<option value="Micro L">Micro L : $4,00 USD - monthly</option>
	<option value="Basic S">Basic S : $5,00 USD - monthly</option>
	<option value="Basic M">Basic M : $8,00 USD - monthly</option>
	<option value="Basic L">Basic L : $10,00 USD - monthly</option>
	<option value="Pro S">Pro S : $15,00 USD - monthly</option>
	<option value="Pro M">Pro M : $30,00 USD - monthly</option>
</select> </td></tr>
</table>
<input type="hidden" name="currency_code" value="USD">
<input type="image" src="https://www.paypalobjects.com/en_US/AT/i/btn/btn_subscribeCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
</form>
</div>

