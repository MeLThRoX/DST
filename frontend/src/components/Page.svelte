<script>
	import Navbar from './navbar.svelte';
	import Footer from './footer.svelte';
</script>

<div class="container mx-auto">
	<Navbar />
	<slot />
	<Footer />
</div>
