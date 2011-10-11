{include file='header'}

<header class="mainHeading">
	<img src="{@RELATIVE_WCF_DIR}icon/time1.svg" alt="" />
	<hgroup>
		<h1>{lang}wcf.acp.cronjob.list{/lang}</h1>
		<h2>{lang}wcf.acp.cronjob.subtitle{/lang}</h2>
	</hgroup>
	
	<script type="text/javascript">
		//<![CDATA[
		$(function() {
			new WCF.Action.Delete('wcf\\data\\cronjob\\CronjobAction', $('.cronjobRow'));
			new WCF.Action.Toggle('wcf\\data\\cronjob\\CronjobAction', $('.cronjobRow'));
			new WCF.Action.SimpleProxy({
				action: 'execute',
				className: 'wcf\\data\\cronjob\\CronjobAction',
				elements: $('.cronjobRow .executeButton')
			}, {
				success: function(data, statusText, jqXHR) {
					$('.cronjobRow').each(function(index, row) {
						$button = $(row).find('.executeButton');
						
						if (WCF.inArray($($button).data('objectID'), data.objectIDs)) {
							// insert feedback here
							$(row).find('td.columnNextExec').html(data.returnValues[$($button).data('objectID')].formatted);
							$(row).wcfHighlight();
						}
					});
				}
			});
		});
		//]]>
	</script>
</header>

<div class="contentHeader">
	{pages print=true assign=pagesLinks link="index.php/CronjobList/?pageNo=%d&sortField=$sortField&sortOrder=$sortOrder"|concat:SID_ARG_2ND_NOT_ENCODED}
	
	{if $__wcf->session->getPermission('admin.system.cronjob.canAddCronjob')}
		<nav class="largeButtons">
			<ul><li><a href="index.php/CronjobAdd/{@SID_ARG_1ST}" title="{lang}wcf.acp.cronjob.add{/lang}"><img src="{@RELATIVE_WCF_DIR}icon/add1.svg" alt="" /> <span>{lang}wcf.acp.cronjob.add{/lang}</span></a></li></ul>
		</nav>
	{/if}
</div>

{hascontent}
	<div class="border boxTitle">
		<hgroup>
			<h1>{lang}wcf.acp.cronjob.list{/lang} <span class="badge" title="{lang}wcf.acp.cronjob.list.count{/lang}">{#$items}</span></h1>
		</hgroup>
		
		<table>
			<thead>
				<tr>
					<th class="columnID columnCronjobID{if $sortField == 'cronjobID'} active{/if}" colspan="2"><a href="index.php/CronjobList/?pageNo={@$pageNo}&amp;sortField=cronjobID&amp;sortOrder={if $sortField == 'cronjobID' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{@SID_ARG_2ND}">{lang}wcf.global.objectID{/lang}{if $sortField == 'cronjobID'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}.svg" alt="" />{/if}</a></th>
					<th class="columnDate columnStartMinute{if $sortField == 'startMinute'} active{/if}" title="{lang}wcf.acp.cronjob.startMinute{/lang}"><a href="index.php/CronjobList/?pageNo={@$pageNo}&amp;sortField=startMinute&amp;sortOrder={if $sortField == 'startMinute' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{@SID_ARG_2ND}">{lang}wcf.acp.cronjob.startMinuteShort{/lang}{if $sortField == 'startMinute'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}.svg" alt="" />{/if}</a></th>
					<th class="columnDate columnStartHour{if $sortField == 'startHour'} active{/if}" title="{lang}wcf.acp.cronjob.startHour{/lang}"><a href="index.php/CronjobList/?pageNo={@$pageNo}&amp;sortField=startHour&amp;sortOrder={if $sortField == 'startHour' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{@SID_ARG_2ND}">{lang}wcf.acp.cronjob.startHourShort{/lang}{if $sortField == 'startHour'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}.svg" alt="" />{/if}</a></th>
					<th class="columnText columnStartDom{if $sortField == 'startDom'} active{/if}" title="{lang}wcf.acp.cronjob.startDom{/lang}"><a href="index.php/CronjobList/?pageNo={@$pageNo}&amp;sortField=startDom&amp;sortOrder={if $sortField == 'startDom' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{@SID_ARG_2ND}">{lang}wcf.acp.cronjob.startDomShort{/lang}{if $sortField == 'startDom'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}.svg" alt="" />{/if}</a></th>
					<th class="columnDate columnStartMonth{if $sortField == 'startMonth'} active{/if}" title="{lang}wcf.acp.cronjob.startMonth{/lang}"><a href="index.php/CronjobList/?pageNo={@$pageNo}&amp;sortField=startMonth&amp;sortOrder={if $sortField == 'startMonth' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{@SID_ARG_2ND}">{lang}wcf.acp.cronjob.startMonthShort{/lang}{if $sortField == 'startMonth'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}.svg" alt="" />{/if}</a></th>
					<th class="columnDate columnStartDow{if $sortField == 'startDow'} active{/if}" title="{lang}wcf.acp.cronjob.startDow{/lang}"><a href="index.php/CronjobList/?pageNo={@$pageNo}&amp;sortField=startDow&amp;sortOrder={if $sortField == 'startDow' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{@SID_ARG_2ND}">{lang}wcf.acp.cronjob.startDowShort{/lang}{if $sortField == 'startDow'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}.svg" alt="" />{/if}</a></th>
					<th class="columnText columnDescription{if $sortField == 'description'} active{/if}"><a href="index.php/CronjobList/?pageNo={@$pageNo}&amp;sortField=description&amp;sortOrder={if $sortField == 'description' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{@SID_ARG_2ND}">{lang}wcf.acp.cronjob.description{/lang}{if $sortField == 'description'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}.svg" alt="" />{/if}</a></th>
					<th class="columnDate columnNextExec{if $sortField == 'nextExec'} active{/if}"><a href="index.php/CronjobList/?pageNo={@$pageNo}&amp;sortField=nextExec&amp;sortOrder={if $sortField == 'nextExec' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{@SID_ARG_2ND}">{lang}wcf.acp.cronjob.nextExec{/lang}{if $sortField == 'nextExec'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}.svg" alt="" />{/if}</a></th>
					
					{if $additionalHeadColumns|isset}{@$additionalHeadColumns}{/if}
				</tr>
			</thead>
			
			<tbody>
				{content}
					{foreach from=$objects item=cronjob}
						<tr class="cronjobRow">
							<td class="columnIcon">
								{if $__wcf->session->getPermission('admin.system.cronjob.canEditCronjob')}
									<img src="{@RELATIVE_WCF_DIR}icon/run1.svg" alt="" title="{lang}wcf.acp.cronjob.execute{/lang}" data-objectID="{@$cronjob->cronjobID}" class="executeButton balloonTooltip" />
								{else}
									<img src="{@RELATIVE_WCF_DIR}icon/run1D.svg" alt="" title="{lang}wcf.acp.cronjob.execute{/lang}" />
								{/if}
						
								{if $cronjob->canBeDisabled()}
									<img src="{@RELATIVE_WCF_DIR}icon/{if $cronjob->active}enabled{else}disabled{/if}1.svg" alt="" data-objectID="{@$cronjob->cronjobID}" data-disableMessage="{lang}wcf.global.button.disable{/lang}" data-enableMessage="{lang}wcf.global.button.enable{/lang}" title="{lang}wcf.global.button.{if $cronjob->active}disable{else}enable{/if}{/lang}" class="toggleButton balloonTooltip" />
								{else}
									{if $cronjob->active}
										<img src="{@RELATIVE_WCF_DIR}icon/enabled1D.svg" alt="" title="{lang}wcf.global.button.disable{/lang}" />
									{else}
										<img src="{@RELATIVE_WCF_DIR}icon/disabled1D.svg" alt="" title="{lang}wcf.global.button.enable{/lang}" />
									{/if}
								{/if}
						
								{if $cronjob->isEditable()}
									<a href="index.php/CronjobEdit/{@$cronjob->cronjobID}/{@SID_ARG_1ST}"><img src="{@RELATIVE_WCF_DIR}icon/edit1.svg" alt="" title="{lang}wcf.global.button.edit{/lang}" class="balloonTooltip" /></a>
								{else}
									<img src="{@RELATIVE_WCF_DIR}icon/edit1D.svg" alt="" title="{lang}wcf.global.button.edit{/lang}" />
								{/if}
								{if $cronjob->isDeletable()}
									<img src="{@RELATIVE_WCF_DIR}icon/delete1.svg" alt="" data-objectID="{@$cronjob->cronjobID}" data-confirmMessage="{lang}wcf.acp.cronjob.delete.sure{/lang}" title="{lang}wcf.global.button.delete{/lang}" class="deleteButton balloonTooltip" />
								{else}
									<img src="{@RELATIVE_WCF_DIR}icon/delete1D.svg" alt="" title="{lang}wcf.global.button.delete{/lang}" />
								{/if}
								{if $additionalButtons[$cronjob->cronjobID]|isset}{@$additionalButtons[$cronjob->cronjobID]}{/if}
							</td>
							<td class="columnID"><p>{@$cronjob->cronjobID}</p></td>
							<td class="columnDate columnStartMinute"><p>{$cronjob->startMinute|truncate:30:' ...'}</p></td>
							<td class="columnDate columnStartHour"><p>{$cronjob->startHour|truncate:30:' ...'}</p></td>
							<td class="columnDate columnStartDom"><p>{$cronjob->startDom|truncate:30:' ...'}</p></td>
							<td class="columnDate columnStartMonth"><p>{$cronjob->startMonth|truncate:30:' ...'}</p></td>
							<td class="columnDate columnStartDow"><p>{$cronjob->startDow|truncate:30:' ...'}</p></td>
							<td class="columnText columnDescription" title="{$cronjob->description}">
								{if $cronjob->isEditable()}
									<p><a title="{lang}wcf.acp.cronjob.edit{/lang}" href="index.php/CronjobEdit/{@$cronjob->cronjobID}/{@SID_ARG_1ST}">{$cronjob->description|truncate:50:" ..."}</a></p>
								{else}
									<p>{$cronjob->description|truncate:50:' ...'}</p>
								{/if}
							</td>
							<td class="columnDate columnNextExec">
								{if $cronjob->active && $cronjob->nextExec != 1}
									<p>{@$cronjob->nextExec|plainTime}</p>
								{/if}
							</td>
					
							{if $additionalColumns[$cronjob->cronjobID]|isset}{@$additionalColumns[$cronjob->cronjobID]}{/if}
						</tr>
					{/foreach}
				{/content}
			</tbody>
		</table>
		
	</div>
	
	<div class="contentFooter">
		{@$pagesLinks}
		
		{if $__wcf->session->getPermission('admin.system.cronjob.canAddCronjob')}
			<nav class="largeButtons">
				<ul><li><a href="index.php/CronjobAdd/{@SID_ARG_1ST}" title="{lang}wcf.acp.cronjob.add{/lang}"><img src="{@RELATIVE_WCF_DIR}icon/add1.svg" alt="" /> <span>{lang}wcf.acp.cronjob.add{/lang}</span></a></li></ul>
			</nav>
		{/if}
	</div>
{hascontentelse}
	<div class="border content">
		<div class="container-1">
			<p class="warning">{lang}wcf.acp.cronjob.noneAvailable{/lang}</p>
		</div>
	</div>
{/hascontent}

{include file='footer'}
