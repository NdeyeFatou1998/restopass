<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateVigilsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('vigils', function (Blueprint $table) {
            $table->id();
            $table->string("name");
            $table->string("telephone");
            $table->string("matricule")->unique();
            $table->string("password");
            $table->string("image_path")->nullable();

            $table->unsignedBigInteger("resto_id")->nullable();
            $table->foreign("resto_id")->references("id")->on("restos")->onDelete('set null');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('vigils');
    }
}
