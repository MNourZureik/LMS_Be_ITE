<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('student_has__answers', function (Blueprint $table) {
            $table->id();
            $table->integer('answer_id');
            $table->foreignId('student_id')->constrained('Students')->cascadeOnDelete();
            $table->foreignId('question_id')->constrained('Questions')->cascadeOnDelete();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('student_has__answers');
    }
};
