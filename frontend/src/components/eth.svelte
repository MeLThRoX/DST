<script>
// @ts-nocheck
	import { ethers } from "ethers"
	import { onMount } from "svelte";
	import { connected, provider, contracts, signerAddress, defaultEvmStores } from 'svelte-ethers-store'

    import abi from '../ABI.json'
	import ERC20 from '../ERC20.json'
	import { contract_address } from '../config.json'

	let pending = false

	defaultEvmStores.attachContract('shop', contract_address, abi)
	defaultEvmStores.attachContract('erc20', "0xc778417E063141139Fce010982780140Aa0cD5Ab", ERC20)

	const connect = async () => {
		pending = true
		try {
			await ethereum.request({ method: 'eth_requestAccounts'})
			await defaultEvmStores.setProvider(new ethers.providers.Web3Provider(ethereum))
			
			pending = false
		} catch(e) {
			console.error(e)
			pending = false
		}
	}

	const disconnect = async () => {
		await defaultEvmStores.disconnect()
		pending = false
	}

	onMount(async () => {
		connect()
	})
</script>

<div class="mt-5 mb-2 text-gray-300 dark:text-slate-700">
	{#if $connected}
		<div class="flex justify-between">
			<p>{$signerAddress}</p>
			<button class="button" disabled={pending} on:click={disconnect}>Disconnect</button>
		</div>
	{:else}
		<div class="flex justify-end">
			<button class="button" disabled={pending} on:click={connect}>Connect</button>
		</div>
	{/if}
</div>