<script>
	import Navbar from './navbar.svelte';
	import Footer from './footer.svelte';
	import Eth from './eth.svelte'
	import { connected } from 'svelte-ethers-store'
</script>

<div class="container mx-auto">
	<Eth />
	<Navbar />
	{#if $connected}
		<slot />
	{:else}
		<p>Connect wallet to continue!</p>
	{/if}
	<Footer />
</div>